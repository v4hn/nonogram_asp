#!/usr/bin/env python

import sys
import re
from colored import bg

while True:
	line= sys.stdin.readline().strip()
	if line.find("SATISFIABLE") > -1:
		break

	row_cnt= int(re.match('.*row_cnt\(([0-9]*)\).*', line).groups()[0])
	col_cnt= int(re.match('.*col_cnt\(([0-9]*)\).*', line).groups()[0])

	items= [ re.match('s\(([^,]*),([^,]*),(.*)\)', i) for i in line.split(" ") ]
	def convertidx(x):
		return (int(x[0]), int(x[1]))
	def convertcolor(x):
		return str(x[2])
	items= { convertidx(m.groups()) : convertcolor(m.groups()) for m in items if m }

	for m in range(row_cnt):
		for n in range(col_cnt):
			try:
				sys.stdout.write({
					'r' : bg('red'),
					'b' : bg('black'),
					'g' : bg('green'),
					'u' : bg('blue'),
					'y' : bg('yellow'),
					'c' : bg('cyan'),
					'o' : bg('orange_3'),
					'p' : bg('purple_1a'),
					'w' : bg('rosy_brown')
					}[items[(m,n)]])
				sys.stdout.write(items[(m,n)])
			except:
				sys.stdout.write(bg('white')+' ')
		sys.stdout.write(bg("black")+'\n')
	sys.stdout.write( bg("black") + ("~" * col_cnt) + "\n" )

sys.stdout.write(bg("black")+'\n')
