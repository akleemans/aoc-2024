import subprocess
import time

# Test for compiling & running Nim code

if __name__ == '__main__':
    for d in range(1, 26):
        p = 'day' + str(d).zfill(2)
        if d in [17, 13]:
            # Days in Python
            print(p, ': -')
            continue
        subprocess.run(['/home/adrianus/.nimble/bin/nim', 'compile', ' -d:release', ' -d:danger', f'{p}.nim'])
        start_time = time.time()
        print(p)
        subprocess.run([f'./{p}'])
        subprocess.run(['rm', f'./{p}'])
