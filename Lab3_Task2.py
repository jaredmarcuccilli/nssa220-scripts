import sys
import os

# Jared Marcuccilli
# NSSA-220 Lab 3 Task 2

# Comment this line to actually use command line args
#sys.argv = [sys.argv[0], 'md5.txt']

filePath = "/usr/bin/"

# --- Functions ---
def read_data(_fName):
    print ("Reading data...")
    f = open(_fName, 'r')
    line = f.readline().strip()
    os.system('rm md5_local.txt')

    # Read in all files and get hashes for local files
    while line:
        #print (line)
        data = line.split(" ")
        file = data[0]
        hash = data[1]

        result = os.system('md5sum ' + filePath + file + ' >> md5_local.txt 2> /dev/null')
        if (result == 256):
            os.system('echo "0 0" >> md5_local.txt')
        line = f.readline().strip()
        
    f.close()
    
    # Compare lines in provided file to md5_local.txt
    print ("Comparing hashes...")
    f = open(_fName, 'r')
    line = f.readline().strip()
    fLocal = open("md5_local.txt", "r")
    lineLocal = fLocal.readline().strip()

    while lineLocal:
        data = line.split(" ")
        dataLocal = lineLocal.split(" ")
        file = data[0]
        hash = data[1]
        localHash = dataLocal[0]
        if (localHash != "0"):
            if (hash != localHash):
                print (file + ": MD5 Original = " + hash + ", MD5 New = " + localHash)

        line = f.readline().strip()
        lineLocal = fLocal.readline().strip()
            
    f.close()
    fLocal.close()
    
# --- Main Program ---
if (len(sys.argv) != 2) :
    print ("Usage: " + sys.argv[0] + " <file>")
    sys.exit()
    
fName = sys.argv[1]
print ("Using " + fName)

read_data(fName)
