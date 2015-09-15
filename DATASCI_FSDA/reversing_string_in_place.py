string = 'I am a happy camper'

def reverse_in_place(string):
    l = string.split()
    reversed_list = ''
    for i in range(0,len(l)):
        l[i] = l[i][::-1]
    return reversed_list.join(l)
    



