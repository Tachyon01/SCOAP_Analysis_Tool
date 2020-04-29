#Header Files
import json

#functions
def check(inp,prefix):
    if inp=='1':
        return '1'
    elif inp=='0':
        return '0'
    elif inp=='x':
        return 'x'
    else:
        return prefix+str(inp)

def cells(cell,x,prefix):
        y = cell.get(x,None)
        ty = y['type']
        print(ty)
        connect = y['connections']
        if ty=='$_NOT_':
                typ = 'not'
                inp1=connect['A']
                inpA=check(inp1[0],prefix)
                out1=connect['Y']
                outY=out1[0]
                line =  prefix+str(outY)+'='+typ+'('+inpA+')\n'
        elif ty=='$_DFF_N_' or ty=='$_DFF_P_':
                typ = 'dffc'
                inp1=connect['C']
                inpC=check(inp1[0],prefix)
                inp2=connect['D']
                inpD=check(inp2[0],prefix)
                out1=connect['Q']
                outQ=out1[0]
                line =  prefix+str(outQ)+'='+typ+'('+str(inpD)+','+str(inpC)+')\n'
        elif ty=='$_DFF_NP0_' or ty=='$_DFF_PP0_' or ty=='$_DFF_PN0_' or ty=='$_DFF_PN1_':
                typ = 'dffcr'
                inp1=connect['C']
                inpC=check(inp1[0],prefix)
                inp2=connect['D']
                inpD=check(inp2[0],prefix)
                inp3=connect['R']
                inpR=check(inp3[0],prefix)
                out1=connect['Q']
                outQ=out1[0]
                line =  prefix+str(outQ)+'='+typ+'('+str(inpD)+','+str(inpC)+','+str(inpR)+')\n'
        elif ty=='$_DFFSR_PPP_':
                inp1=connect['C']
                inpC=check(inp1[0],prefix)
                inp2=connect['D']
                inpD=check(inp2[0],prefix)
                inp3=connect['R']
                inpR=check(inp3[0],prefix)
                inp4=connect['S']
                inpS=check(inp4[0],prefix)
                out1=connect['Q']
                outQ=out1[0]
                line1 =  str(outQ)+'_dffsr'+'='+'dffcr'+'('+str(inpD)+','+str(inpC)+','+str(inpR)+')\n'
                line2 = prefix+str(outQ)+'='+'or'+'('+str(outQ)+'_dffsr'+','+str(inpS)+')\n'
                line = line1+line2
        elif ty=='$_XOR_':
                typ='xor'
                inp1=connect['A']
                inpA=check(inp1[0],prefix)
                inp2=connect['B']
                inpB=check(inp2[0],prefix)
                out1=connect['Y']
                outY=out1[0]
                line =  prefix+str(outY)+'='+typ+'('+str(inpA)+','+str(inpB)+')\n'
        elif ty=='$_OR_':
                typ='or'
                inp1=connect['A']
                inpA=check(inp1[0],prefix)
                inp2=connect['B']
                inpB=check(inp2[0],prefix)
                out1=connect['Y']
                outY=out1[0]
                line =  prefix+str(outY)+'='+typ+'('+str(inpA)+','+str(inpB)+')\n'
        elif ty=='$_AND_':
                typ='and'
                inp1=connect['A']
                inpA=check(inp1[0],prefix)
                inp2=connect['B']
                inpB=check(inp2[0],prefix)
                out1=connect['Y']
                outY=out1[0]
                line =  prefix+str(outY)+'='+typ+'('+str(inpA)+','+str(inpB)+')\n'
        elif ty=='$_MUX_':
                typ='mux'
                inp1=connect['A']
                inpA=check(inp1[0],prefix)
                inp2=connect['B']
                inpB=check(inp2[0],prefix)
                inp3=connect['S']
                inpS=check(inp3[0],prefix)
                out1=connect['Y']
                outY=out1[0]
                not1=str(inpS)+'_'+'not'+'='+'not('+str(inpS)+')\n'
                and1=str(inpA)+'_'+str(inpS)+'_'+'and'+'='+'and('+str(inpA)+','+str(inpS)+'_'+'not'+')\n'
                and2=str(inpB)+'_'+str(inpS)+'_'+'and'+'='+'and('+str(inpB)+','+str(inpS)+')\n'
                or1 =prefix+str(outY)+'='+'or('+str(inpA)+'_'+str(inpS)+'_'+'and'+','+str(inpB)+'_'+str(inpS)+'_'+'and'+')\n'
                line=not1+and1+and2+or1
                #line =  prefix+str(outY)+'='+typ+'('+str(inpA)+','+str(inpB)+','+str(inpS)+')\n'
        else:
                line = '#Submodule '+ty+'\n'
                fileOut.write(line)
                subModule(y,prefix+str(x)+'_')
                line = '#Submodule Close '+ty+'\n'
        fileOut.write(line)

def subModule(y,prefix):
        ty=y['type']
        connect = y['connections']
        Sub = modules[ty]
        #print(connect)
        cell = Sub['cells']
        for z in connect:
                temp=connect.get(z,None)
               #print(temp)
                length = len(temp) 
                for i in range(length):
                    rhs = str(temp[i])
                    lhs = prefix+str(Sub['ports'][z]['bits'][i])
                    if Sub['ports'][z]['direction']=='output':
                        swap=rhs
                        rhs=lhs
                        lhs=swap
                    line = lhs+'='+rhs+'\n'
                    #line = prefix+z+'='+str(z)+'\n'
                    fileOut.write(line)
        for q in cell:
            cells(cell,q,prefix)



#main block

fileIn = open("Jsonscript.txt","r") #Open json file
fileOut = open("OutToScoap.txt","w") #output file

content = fileIn.read() #To copy input file in a variable
content_dict = json.loads(content) #read as json
# print(content_dict) #if wanna check
modules = content_dict['modules']  #reach modules

#start parsing modules
Top = modules['uart']  #to required module
ports = Top['ports'] #to ports
fileOut.write('input(0)\ninput(1)\ninput(x)\n')
for x in ports:                 #loop for getting ports
        #print(x)
        y = ports[x]
        #print(y)
        dirc = y['direction']
        bits = y['bits']
        for i in bits:
                line1 = dirc+'('+str(i)+')'+'\n'
                line2 = '#' + x +'  '+ dirc + ' ' + str(i)+'\n'
                #print(line1)
                fileOut.write(line1)
                fileOut.write(line2)

cell = Top['cells']
for x in cell:
        cells(cell,x,'')

fileIn.close()
fileOut.close()
