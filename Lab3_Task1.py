import sys
import math

# Jared Marcuccilli
# NSSA-220 Lab 3 Task 1

# Comment this line to actually use command line args
#sys.argv = [sys.argv[0], 'iris_full.txt']

# --- Functions ---
def read_data(_fName, _flowerList):
    print ("Reading data...")
    f = open(_fName, 'r')
    line = f.readline().strip()

    # Skip to first line with data
    while (not line[:1].isdigit()):
        line = f.readline().strip()
        
    while line:
        #print (line)
        if (line[:1].isdigit()): # Make sure it's not a blank line (I was getting one at the end)
            #print line
            data = line.split(",")
            #print (data)
            flowerList[0].append(data[0])
            flowerList[1].append(data[1])
            flowerList[2].append(data[2])
            flowerList[3].append(data[3])
            flowerList[4].append(data[4])
        line = f.readline().strip()
            
    f.close()

def process_numeric_field(_flowerList, _field):
    usingList = _flowerList[_field]
    usingList.sort()
    
    # Find the average
    total = 0
    count = 0
    for x in usingList:
        total += float(x)
        count = count + 1

    avg = total / count

    # Find the min
    smallest = usingList[0]

    # Find the max
    biggest = usingList[-1]

    # Standard deviation calculations...
    meanSquareTotal = 0
    for x in usingList:
        meanSquareTotal = meanSquareTotal + (float(x) - avg)**2
    stdDev = math.sqrt(meanSquareTotal / count)
    #print (stdDev)

    return (float(avg), float(smallest), float(biggest), float(stdDev))

def count_iris_types(_flowerList):
    usingList = _flowerList[4]

    setosaCount = 0
    versicolorCount = 0
    virginicaCount = 0
    
    for x in usingList:
        if (x == "Iris-setosa"):
            setosaCount = setosaCount + 1
        elif (x == "Iris-versicolor"):
            versicolorCount = versicolorCount + 1
        elif (x == "Iris-virginica"):
            virginicaCount = virginicaCount + 1

    return (str(setosaCount), str(versicolorCount), str(virginicaCount))

# --- Main Program ---
if (len(sys.argv) != 2) :
    print ("Usage: " + sys.argv[0] + " <file>")
    sys.exit()

fName = sys.argv[1]
print ("Using " + fName)

sepalLengthList = []
sepalWidthList = []
petalLengthList = []
petalWidthList = []
irisTypeList = []

flowerList = [sepalLengthList, sepalWidthList, petalLengthList, petalWidthList, irisTypeList] 

read_data(fName, flowerList)

# The instructions say to pass what field to process_numeric_field, so I'll do all 4 here.
#x = 1
for field in range(4):
    #field = field - 1
    # Process data for field x
    avg, smallest, biggest, stdDev = process_numeric_field(flowerList, field)
    setosaCount, versicolorCount, virginicaCount = count_iris_types(flowerList)

    if (field == 0):
        print ("Sepal Length: min = %.2f max = %.2f average = %.2f standard deviation = %.4f" % (smallest, biggest, avg, stdDev))
    elif (field == 1):
        print ("Sepal Width: min = %.2f max = %.2f average = %.2f standard deviation = %.4f" % (smallest, biggest, avg, stdDev))
    elif (field == 2):
        print ("Petal Length: min = %.2f max = %.2f average = %.2f standard deviation = %.4f" % (smallest, biggest, avg, stdDev))
    elif (field == 3):
        print ("Petal Width: min = %.2f max = %.2f average = %.2f standard deviation = %.4f" % (smallest, biggest, avg, stdDev))

print ("Iris Types: Iris Setosa = " + setosaCount + ", Iris Versicolor = " + versicolorCount + ", Iris Virginica = " + virginicaCount)
