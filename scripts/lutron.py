
import pexpect
import re

child = pexpect.spawn('telnet 192.168.1.62')

child.expect('login: ')
child.sendline('lutron')
child.expect('password: ')
child.sendline('integration')
child.expect('login: ')
child.sendline('lutron')
child.expect('password: ')
child.sendline('integration')
while(True):
    child.expect('~.*')
    print(child.after)
