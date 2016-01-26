## Steps
# 1. Read each line into a list, nest this list in the master
# 2. Choose Second to last list, compare to last list
# 3. Replace last list with relevant summed list from prior 
# 4. Repeat until sum is defined


#initialize list
storage = []

#open file and read data into list
with open("/Users/gregce/MIDS/Euler/triangle.txt","r") as f:
    for line in f.readlines():
        data_line = map(int, line.split()) #convert strings to integers
        storage.append(np.array(data_line)) #append nested arrays

#convert list to an array
a = np.array(storage)

# define function to reduce array
def reduceArray(arr):
    list_store = []
    second_to_last = len(arr)-2
    last = len(arr)-1
    for i in range(len(arr[second_to_last])):
        max = 0 
        for j in range(len(arr[last])):
            if i == j or i+1 == j:
                if arr[second_to_last][i] + arr[last][j] > max:
                    max = arr[second_to_last][i] + arr[last][j]
        list_store.append(max)
    return(np.array(list_store))

# prototype how to iterate through the array once reduced
# 
test = a.tolist()

new = test[:-2]
new.append(reduceArray(test))

new = np.concatenate(np.delete(test,np.s_[2:4],0), np.array(reduceArray(test)))

new




##intial prototype code
for i in range(len(a[2])):
    max = 0 
    for j in range(len(a[3])):
        if i == j or i+1 == j:
            if a[2][i] + a[3][j] > max:
                max = a[2][i] + a[3][j]
    list_store.append(max)
    reduced_array = np.array(list_store)
list_store
reduced_array




    
    
    