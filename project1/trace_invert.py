'''
script to invert control path tracefile
author: Pranav Sankhe [pranavsankhe40@gmail.com, https://sabsathai.github.io/, https://github.com/sabSAThai ]
'''

file_path = '/home/pranav/Sem5/microLab/MicroprocessorsLab-master/project1/tracefile.txt'  

infile  = open(file_path)
outfile = open("datapath_trace.txt", "w")
count = 0 
for line in infile:
    line = line.split('\n')[0]
    print line 
    inputs   =  line.split(' ')[0]
    outputs  =  line.split(' ')[1]
    comments =  line.split(' ')[2] + ' ' + line.split(' ')[3] 

    count  = count + 1
    write_line = outputs + ' ' + inputs + '  ' + comments + '\n' 
    outfile.write(write_line)


