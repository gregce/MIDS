'''
R-1.1 Write a short Python function, is multiple(n, m), 
that takes two integer values and returns True if n is a
multiple of m, that is, n = mi for some integer i, and False otherwise.
'''
def is_multiple(n,m):
    '''R-1.1 Write a short Python function, is multiple(n, m), 
    that takes two integer values and returns True if n is a
    multiple of m, that is, n = mi for some integer i, and False otherwise.
    '''
    i=1
    while i<n+1:
        ##print m*i
        if n==m*i:
           return True
        i+=1
    return False

test = is_multiple(8,2)
        
'''
Write a short Python function, is even(k), that takes an integer value
and returns True if k is even, and False otherwise. However, your function 
cannot use the multiplication, modulo, or division operators.'''

def even(k):
    test=k
    while test>-2:
        if test==1:
            return False
        test-=2
    return True

test1 = even(10)
        
'''        
R-1.3 Write a short Python function, minmax(data), that takes a sequence of one or more numbers, 
and returns the smallest and largest numbers, in the form of a tuple of length two.
Do not use the built-in functions min or max in implementing your solution.'''      


def minmax(data):
    minimum=data[0]
    maximum=0
    for val in data:
        print val        
        if val < minimum:
            minimum=val
        elif val >= maximum:
            maximum=val
    return (minimum,maximum)

test2 = minmax([-1,30,5,10,15,20])

'''
Write a short Python function that takes a positive integer n 
and returns the sum of the squares of all the positive integers smaller than n.  
'''

def sumofsquares(n):
    return sum((k*k for k in xrange(1, n+1)))
    
    
    
    
    
    
        
        
         
                  
                                    
        
