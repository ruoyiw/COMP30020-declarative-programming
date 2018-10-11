from __future__ import division

def getAverage():
    count = 0
    found = 0
    lines = open("LOG","r").readlines()
    for line in lines:
        tokens = line.split()
        if "guesses!" in tokens:
            count+=int(tokens[4])
            found+=1

    print "successfully found", found, "out of 1330"
    print "average number of guesses required: ", (count/found)


getAverage()
