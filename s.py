#game grid
'''
grid = [[8,0,0,9,3,0,0,0,2],\
       [0,0,9,0,0,0,0,4,0],\
       [7,0,2,1,0,0,9,6,0],\
       [2,0,0,0,0,0,0,9,0],\
       [0,6,0,0,0,0,0,7,0],\
       [0,7,0,0,0,6,0,0,5],\
       [0,2,7,0,0,8,4,0,6],\
       [0,3,0,0,0,0,5,0,0],\
       [5,0,0,0,6,2,0,0,8]]
'''
grid = [[3,0,0,0,0,0,0,0,8],\
        [0,2,0,0,0,0,0,1,0],\
        [0,0,1,6,5,2,3,0,0],\
        [0,0,2,5,9,3,6,0,0],\
        [0,0,4,0,0,0,8,0,0],\
        [0,0,6,2,0,4,9,0,0],\
        [0,0,8,1,3,5,7,0,0],\
        [0,5,0,0,0,0,0,8,0],\
        [6,0,0,0,0,0,0,0,9]]
       
#3x3 'block' zones, format: [[positions],[possible vals]]
# also (i,j) ==> i-th row, j-th column.
bzones = [[[(0,0),(0,1),(0,2),(1,0),(1,1),(1,2),(2,0),(2,1),(2,2)],\
          [(0,3),(0,4),(0,5),(1,3),(1,4),(1,5),(2,3),(2,4),(2,5)],\
          [(0,6),(0,7),(0,8),(1,6),(1,7),(1,8),(2,6),(2,7),(2,8)],\
          [(3,0),(3,1),(3,2),(4,0),(4,1),(4,2),(5,0),(5,1),(5,2)],\
          [(3,3),(3,4),(3,5),(4,3),(4,4),(4,5),(5,3),(5,4),(5,5)],\
          [(3,6),(3,7),(3,8),(4,6),(4,7),(4,8),(5,6),(5,7),(5,8)],\
          [(6,0),(6,1),(6,2),(7,0),(7,1),(7,2),(8,0),(8,1),(8,2)],\
          [(6,3),(6,4),(6,5),(7,3),(7,4),(7,5),(8,3),(8,4),(8,5)],\
          [(6,6),(6,7),(6,8),(7,6),(7,7),(7,8),(8,6),(8,7),(8,8)]],\
          [[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],\
          [1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],\
          [1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9]]]

#column zones
czones=[[[(0,0),(1,0),(2,0),(3,0),(4,0),(5,0),(6,0),(7,0),(8,0)],\
        [(0,1),(1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1)],\
        [(0,2),(1,2),(2,2),(3,2),(4,2),(5,2),(6,2),(7,2),(8,2)],\
        [(0,3),(1,3),(2,3),(3,3),(4,3),(5,3),(6,3),(7,3),(8,3)],\
        [(0,4),(1,4),(2,4),(3,4),(4,4),(5,4),(6,4),(7,4),(8,4)],\
        [(0,5),(1,5),(2,5),(3,5),(4,5),(5,5),(6,5),(7,5),(8,5)],\
        [(0,6),(1,6),(2,6),(3,6),(4,6),(5,6),(6,6),(7,6),(8,6)],\
        [(0,7),(1,7),(2,7),(3,7),(4,7),(5,7),(6,7),(7,7),(8,7)],\
        [(0,8),(1,8),(2,8),(3,8),(4,8),(5,8),(6,8),(7,8),(8,8)]],\
        [[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],\
        [1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],\
        [1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9]]]

#row zones
rzones=[[[(0,0),(0,1),(0,2),(0,3),(0,4),(0,5),(0,6),(0,7),(0,8)],\
        [(1,0),(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8)],\
        [(2,0),(2,1),(2,2),(2,3),(2,4),(2,5),(2,6),(2,7),(2,8)],\
        [(3,0),(3,1),(3,2),(3,3),(3,4),(3,5),(3,6),(3,7),(3,8)],\
        [(4,0),(4,1),(4,2),(4,3),(4,4),(4,5),(4,6),(4,7),(4,8)],\
        [(5,0),(5,1),(5,2),(5,3),(5,4),(5,5),(5,6),(5,7),(5,8)],\
        [(6,0),(6,1),(6,2),(6,3),(6,4),(6,5),(6,6),(6,7),(6,8)],\
        [(7,0),(7,1),(7,2),(7,3),(7,4),(7,5),(7,6),(7,7),(7,8)],\
        [(8,0),(8,1),(8,2),(8,3),(8,4),(8,5),(8,6),(8,7),(8,8)]],\
        [[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],\
        [1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],\
        [1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9]]]
#all starting positions, filled with sgparse().
starts=[]
def gprint():
    ng=[]
    for i in grid:
        string =''
        for c in i:
            string = string + str(c)+' '
        ng.append(string)
    print ng[0][0:5]+'|'+ng[0][6:11]+'|'+ng[0][12:18]
    print ng[1][0:5]+'|'+ng[1][6:11]+'|'+ng[1][12:18]
    print ng[2][0:5]+'|'+ng[2][6:11]+'|'+ng[2][12:18]
    print '-----------------'
    print ng[3][0:5]+'|'+ng[3][6:11]+'|'+ng[3][12:18]
    print ng[4][0:5]+'|'+ng[4][6:11]+'|'+ng[4][12:18]
    print ng[5][0:5]+'|'+ng[5][6:11]+'|'+ng[5][12:18]
    print '-----------------'
    print ng[6][0:5]+'|'+ng[6][6:11]+'|'+ng[6][12:18]
    print ng[7][0:5]+'|'+ng[7][6:11]+'|'+ng[7][12:18]
    print ng[8][0:5]+'|'+ng[8][6:11]+'|'+ng[8][12:18]

def canplace(v,i,j): #checks to see if v can be placed at coord (i,j)
    val = v
    bi = bindex(i,j)
    if bi == None:
        return 'DNE' #because this position relates to a given value
    if val in czones[1][j]:
        if val in rzones[1][i]:
            if val in bzones[1][bi]:
                return True
    return False

def rval(v,i,j): #removes value from zone possibilities
    bi = bindex(i,j)
    bzones[1][bi].remove(v)
    czones[1][j].remove(v)
    rzones[1][i].remove(v)

def aval(v,i,j): #adds val to zone prosibs.
    bi = bindex(i,j)
    bzones[1][bi].append(v)
    czones[1][j].append(v)
    rzones[1][i].append(v)
    
def place(v,i,j): #changes grid value of (i,j) coord to 'v'.
    grid[i][j] = v
    rval(v,i,j)

def bindex(i,j): #returns index of bzone related to (i,j) coord.
    for m in range(len(bzones[0])):
        if (i,j) in bzones[0][m]:
            return m
        
def won(): #is the game won, currently unused really.
    s=0
    for m in bzones[1]:
        s+= sum(m)
    if s ==0:
        return True
    return False

def incr(i,j): #returns the next playable cell
    j+=1
    if j%9==0:
        j=0
        i+=1
    while (i,j) in starts:
        p = incr(i,j)
        i,j=p[0],p[1]
    return i,j

def decr(i,j): #returns the previous playable cell
    j-=1
    if j<0:
        j=8
        i-=1
    while (i,j) in starts:
        p = decr(i,j)
        i,j=p[0],p[1]
    return i,j
 
def sgparse(): #parses starting grid, re-evals possible vals and cells.
    t = range(9)
    for i in t:
        for j in t:
            val = grid[i][j]
            for m in range(len(bzones[0])):
                if (i,j) in bzones[0][m]:
                    if val in bzones[1][m]:
                        bzones[1][m].remove(val)
                        bzones[0][m].remove((i,j))
                        if val > 0:
                            starts.append((i,j))
            for m in range(len(czones[0])):
                if (i,j) in czones[0][m]:
                    if val in czones[1][m]:
                        czones[1][m].remove(val)
                        czones[0][m].remove((i,j))
            for m in range(len(rzones[0])):
                if (i,j) in rzones[0][m]:
                    if val in rzones[1][m]:
                        rzones[1][m].remove(val)
                        rzones[0][m].remove((i,j))

def r(): #just a quick function to run the solver.
    sgparse()
    ai()

def ai(): #ai for solving the board
    i=0
    j=0
    v=1
    c=0
    while i+j<=16:
        c+=1
        if canplace(v,i,j) == True:
            place(v,i,j)
            p=incr(i,j)
            i,j=p[0],p[1]
            v=1
        elif canplace(v,i,j) == 'DNE':
            p=incr(i,j)
            i,j=p[0],p[1]
            v=1
        else:
            while canplace(v,i,j) == False:
                v+=1
                if canplace(v,i,j) == True:
                    place(v,i,j)
                    p=incr(i,j)
                    i,j=p[0],p[1]
                    v=1
                    break
                if v>8:
                    grid[i][j]=0
                    p=decr(i,j)
                    i,j=p[0],p[1]
                    v = grid[i][j] +1
                    aval(grid[i][j],i,j)
                    break
    print c 
    gprint()



            


                
