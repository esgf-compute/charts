import argparse
import yaml

parser = argparse.ArgumentParser()
parser.add_argument('file1', help='Source file to merge into file2')
parser.add_argument('file2', help='Source that file1 will be merged into')
parser.add_argument('--dry-run', help='Runs without modifying file', action='store_true')

args = parser.parse_args()

with open(args.file1, 'r') as f:
    file1 = yaml.load(f.read(), Loader=yaml.SafeLoader)

with open(args.file2, 'r') as f:
    file2 = yaml.load(f.read(), Loader=yaml.SafeLoader)

def merge(x, y):
    for z in x:
        if z in y:
            if isinstance(y[z], dict):
                y[z] = merge(x[z], y[z])
            else:
                y[z] = x[z]
        else:
            y[z] = x[z]

    return y

merged_data = merge(file1, file2)

if args.dry_run:
    print(merged_data)
else:
    with open(args.file2, 'w') as f:
        yaml.dump(merged_data, f)
