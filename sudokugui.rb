require 'tk'
require 'tkextlib/tile'
root = TkRoot.new {title "Sudoku"}
content = Tk::Tile::Frame.new(root).grid( :sticky => 'nsew')
root.bind("Return") {calculate}

class Cell #cell, aka an entry widget object for each of the 81 'blocks' on the 9x9 grid.
  @@root = TkRoot.new {title "Sudoku"}
  @@content = Tk::Tile::Frame.new(@@root).grid( :sticky => 'nsew')
  Tk::Tile::Button.new(@@content) {text 'Fuck it, solve.'; command "solve"}.grid( :column => 10, :row => 11)
  TkWinfo.children(@@content).each {|w| TkGrid.configure w, :padx => 1, :pady => 1}
  def initialize(i,j) #each cell has a coordinate.
    @g=TkVariable.new
    @f = Tk::Tile::Entry.new(@@content) {width 2; textvariable @g}.grid( :column => j+1, :row => i+1 )
  end
  def text(text)
    display_text = TkVariable.new
    display_text.value = text.to_s
    @f.textvariable = display_text
  end
  def readonly
    @f.configure('state'=>'readonly')
  end
  def val
    @g = @f.get #get dat data, ho.
    if @g == ""
      @g = 0
    end
    return @g.to_i #we're using integers.
  end
end

class Label
  @@root = TkRoot.new {title "Sudoku"}
  @@content = Tk::Tile::Frame.new(@@root).grid( :sticky => 'nsew')
  TkWinfo.children(@@content).each {|w| TkGrid.configure w, :padx => 1, :pady => 1}
  def initialize(i,j) #each cell has a coordinate.
    @lbl=TkLabel.new(@@content){
       text 'Press enter to see if you\'ve won.'
       grid('row'=>i, 'column'=>j)
    }
  end
  def text(text)
    @lbl.text = text.to_s
  end
end

@testlabel = Label. new(9,10)

@gridentry = Array.new(9) {Array.new(9) {0}} #an array to hold all the entry widgets objects.

#game board

@grid = [[8,0,0,9,3,0,0,0,2],\
       [0,0,9,0,0,0,0,4,0],\
       [7,0,2,1,0,0,9,6,0],\
       [2,0,0,0,0,0,0,9,0],\
       [0,6,0,0,0,0,0,7,0],\
       [0,7,0,0,0,6,0,0,5],\
       [0,2,7,0,0,8,4,0,6],\
       [0,3,0,0,0,0,5,0,0],\
       [5,0,0,0,6,2,0,0,8]]
       
''' solution to above, needed it for some debugging.
@grid = [[8, 4, 6, 9, 3, 7, 1, 5, 2],\
[3, 1, 9, 6, 2, 5, 8, 4, 7],\
[7, 5, 2, 1, 8, 4, 9, 6, 3],\
[2, 8, 5, 7, 1, 3, 6, 9, 4],\
[4, 6, 3, 8, 5, 9, 2, 7, 1],\
[9, 7, 1, 2, 4, 6, 3, 8, 5],\
[1, 2, 7, 5, 9, 8, 4, 3, 6],\
[6, 3, 8, 4, 7, 1, 5, 2, 9],\
[5, 9, 4, 3, 6, 2, 7, 1, 8]]
'''
@orig_grid = Marshal.load( Marshal.dump(@grid))

9.times do |i| #initializes the entry widget (Cell) game board.
  9.times do |ii|
    @gridentry[i][ii] = Cell. new(i,ii)
  end
end

######################################################################
#3x3 'block' zones, format: [[positions],[possible vals]]
# also [i,j] ==> i-th row, j-th column.
@bzones = [[[[0,0],[0,1],[0,2],[1,0],[1,1],[1,2],[2,0],[2,1],[2,2]],\
          [[0,3],[0,4],[0,5],[1,3],[1,4],[1,5],[2,3],[2,4],[2,5]],\
          [[0,6],[0,7],[0,8],[1,6],[1,7],[1,8],[2,6],[2,7],[2,8]],\
          [[3,0],[3,1],[3,2],[4,0],[4,1],[4,2],[5,0],[5,1],[5,2]],\
          [[3,3],[3,4],[3,5],[4,3],[4,4],[4,5],[5,3],[5,4],[5,5]],\
          [[3,6],[3,7],[3,8],[4,6],[4,7],[4,8],[5,6],[5,7],[5,8]],\
          [[6,0],[6,1],[6,2],[7,0],[7,1],[7,2],[8,0],[8,1],[8,2]],\
          [[6,3],[6,4],[6,5],[7,3],[7,4],[7,5],[8,3],[8,4],[8,5]],\
          [[6,6],[6,7],[6,8],[7,6],[7,7],[7,8],[8,6],[8,7],[8,8]]],\
          [[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],\
          [1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],\
          [1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9]]]
@orig_bzones = Marshal.load( Marshal.dump(@bzones))
  
#column zones
@czones=[[[[0,0],[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],[8,0]],\
        [[0,1],[1,1],[2,1],[3,1],[4,1],[5,1],[6,1],[7,1],[8,1]],\
        [[0,2],[1,2],[2,2],[3,2],[4,2],[5,2],[6,2],[7,2],[8,2]],\
        [[0,3],[1,3],[2,3],[3,3],[4,3],[5,3],[6,3],[7,3],[8,3]],\
        [[0,4],[1,4],[2,4],[3,4],[4,4],[5,4],[6,4],[7,4],[8,4]],\
        [[0,5],[1,5],[2,5],[3,5],[4,5],[5,5],[6,5],[7,5],[8,5]],\
        [[0,6],[1,6],[2,6],[3,6],[4,6],[5,6],[6,6],[7,6],[8,6]],\
        [[0,7],[1,7],[2,7],[3,7],[4,7],[5,7],[6,7],[7,7],[8,7]],\
        [[0,8],[1,8],[2,8],[3,8],[4,8],[5,8],[6,8],[7,8],[8,8]]],\
        [[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],\
        [1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],\
        [1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9]]]
@orig_czones = Marshal.load( Marshal.dump(@czones))
  
#row zones
@rzones=[[[[0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],[0,8]],\
        [[1,0],[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7],[1,8]],\
        [[2,0],[2,1],[2,2],[2,3],[2,4],[2,5],[2,6],[2,7],[2,8]],\
        [[3,0],[3,1],[3,2],[3,3],[3,4],[3,5],[3,6],[3,7],[3,8]],\
        [[4,0],[4,1],[4,2],[4,3],[4,4],[4,5],[4,6],[4,7],[4,8]],\
        [[5,0],[5,1],[5,2],[5,3],[5,4],[5,5],[5,6],[5,7],[5,8]],\
        [[6,0],[6,1],[6,2],[6,3],[6,4],[6,5],[6,6],[6,7],[6,8]],\
        [[7,0],[7,1],[7,2],[7,3],[7,4],[7,5],[7,6],[7,7],[7,8]],\
        [[8,0],[8,1],[8,2],[8,3],[8,4],[8,5],[8,6],[8,7],[8,8]]],\
        [[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],\
        [1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],\
        [1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9]]]
@orig_rzones = Marshal.load( Marshal.dump(@rzones))
 
#all starting positions, filled with sgparse().
@starts=[]
def gprint() #prints the board.
    for i in @grid
        print i,"\n"
    end
end

def canplace(v,i,j) #checks to see if v can be placed at coord [i,j]
    val = v
    if @starts.include?([i,j])
        return 'DNE' #because this position relates to a given value
    end
    bi = bindex(i,j)
    if @czones[1][j].include?(val) and @rzones[1][i].include?(val) and @bzones[1][bi].include?(val)
        return true
    end
    return false
end

def rval(v,i,j) #removes value from zone possibilities
    bi = bindex(i,j)
    @bzones[1][bi].delete(v)
    @czones[1][j].delete(v)
    @rzones[1][i].delete(v)
end

def aval(v,i,j) #adds val to zone prosibs.
    bi = bindex(i,j)
    @bzones[1][bi].push(v)
    @czones[1][j].push(v)
    @rzones[1][i].push(v)
end

def place(v,i,j) #changes @grid value of [i,j] coord to 'v'.
    @grid[i][j] = v
    rval(v,i,j)
end

def bindex(i,j) #returns index of bzone related to [i,j] coord.
    for m in (0..@bzones[0].length)
        if @bzones[0][m] != nil
            if @bzones[0][m].include?([i,j])
                return m
            end
        end
    end
end

def incr(i,j) #returns the next playable cell
    j+=1
    if j%9==0
        j=0
        i+=1
    end
    while @starts.include?([i,j])
        p = incr(i,j)
        i,j=p[0],p[1]
    end
    return i,j
end

def decr(i,j) #returns the previous playable cell
    j-=1
    if j<0
        j=8
        i-=1
    end
    while @starts.include?([i,j])
        p = decr(i,j)
        i,j=p[0],p[1]
    end
    return i,j
end
 
def sgparse() #parses starting @grid, re-evals possible vals and cells.
    t = (0..8)
    for i in t
        for j in t
            val = @grid[i][j]
            for m in (0..@bzones[0].length)
                if @bzones[0][m] != nil
                    if @bzones[0][m].include?([i,j])
                        if @bzones[1][m].include?(val)
                            @bzones[1][m].delete(val)
                            @bzones[0][m].delete([i,j])
                            if val > 0
                                @starts.push([i,j])
                            end
                        end
                    end
                end
            end
            for m in (0..@czones[0].length)
                if @czones[0][m] != nil
                    if @czones[0][m].include?([i,j])
                        if @czones[1][m].include?(val)
                            @czones[1][m].delete(val)
                            @czones[0][m].delete([i,j])
                        end
                    end
                end
            end
            for m in (0..@rzones[0].length)
                if @rzones[0][m] != nil
                    if @rzones[0][m].include?([i,j])
                        if @rzones[1][m].include?(val)
                            @rzones[1][m].delete(val)
                            @rzones[0][m].delete([i,j])
                        end
                    end
                end
            end
        end
    end
end

def r() #just a quick function to run the solver.
    sgparse()
    ai()
end

def ai() #ai for solving the board, brute force
    i=0
    j=0
    v=1
    c=0
    while i!=9 and j!=9
        c+=1
        if canplace(v,i,j) == true
            place(v,i,j)
            p=incr(i,j)
            i,j=p[0],p[1]
            v=1
        elsif canplace(v,i,j) == 'DNE'
            p=incr(i,j)
            i,j=p[0],p[1]
            v=1
        else
            while canplace(v,i,j) == false
                v+=1
                if canplace(v,i,j) == true
                    place(v,i,j)
                    p=incr(i,j)
                    i,j=p[0],p[1]
                    v=1
                    break
                end
                if v>8
                    @grid[i][j]=0
                    p=decr(i,j)
                    i,j=p[0],p[1]
                    v = @grid[i][j] +1
                    aval(@grid[i][j],i,j)
                    break
                end
            end
        end 
    end
    print c,"\n" 
    gprint()
end
######################################################################

def initboard()
  sgparse()
  for i in (0..8)
    for j in (0..8)
      if @starts.include?([i,j])
        @gridentry[i][j].text(@grid[i][j])
        @gridentry[i][j].readonly
      end
    end
  end
end

initboard() # making it so the user can't fuck up the board.
def playwin()
  for row in @orig_rzones[0]
    rowvals=[]
    for coord in row
      rowvals.push(@grid[coord[0]][coord[1]])
    end
    for cell_val in (1..9)
      if rowvals.include?(cell_val) == false
        return false
      end
    end
  end
  for col in @orig_czones[0]
    colvals=[]
    for coord in col
      colvals.push(@grid[coord[0]][coord[1]])
    end
    for cell_val in (1..9)
      if colvals.include?(cell_val) == false
        return false
      end
    end
  end
  for box in @orig_bzones[0]
    boxvals=[]
    for coord in box
      boxvals.push(@grid[coord[0]][coord[1]])
    end
    for cell_val in (1..9)
      if boxvals.include?(cell_val) == false
        return false
      end
    end
  end
  return true
end

def solve
  @grid = @orig_grid
  r()
  gprint()
  for i in (0..8)
    for j in (0..8)
      @gridentry[i][j].text(@grid[i][j])
      @gridentry[i][j].readonly
    end
  end      
end

def calculate
  begin
    for i in (0..8)
      for j in (0..8)
        @grid[i][j] = @gridentry[i][j].val
        rval(@gridentry[i][j].val,i,j)
      end
    end
    gprint()
    if playwin() == true
      text = 'Yes!  You won!'
    else
      text = 'No, you haven\'t won.'
    end
    @testlabel.text(text)
  rescue
  end
end

Tk.mainloop
