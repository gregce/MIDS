'''
Write a script that prompts the user for their phone number, x. Then carry out the following steps:
 

1. Compute x minus the sum of the digits of x. Call this result y. (hint: to find the sum of the digits of x,
   check to see what x//10 and x%10 give you)

2. Compute the sum of the digits of y, and store the result back in y.

3. Repeat step 2 until y has just one digit, then display it.
 

What answer do you get?
'''
phone_number = int(input("Please enter your phone number as an integer: "))

def sum_digits(n):
    s = 0
    while n:
        ##print n
        s += n % 10
        ##print s
        n /= 10
    return s

y = phone_number - sum_digits(phone_number)

while len(str(y))>1:
    print y
    y = sum_digits(y)