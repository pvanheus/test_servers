#!/usr/bin/env python

import argparse
import sys

def make_template(input_file, output_file):
    print("server 127.0.0.1\nzone sanbi.ac.za", file=output_file)
    for line in input_file:
        (ip, hostname) = line.rstrip().split()
        print("update del {}".format(hostname), file=output_file)
        print("update add {} 86400 A {}".format(hostname, ip), file=output_file)
    print("send", file=output_file)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('input_file', type=argparse.FileType())
    parser.add_argument('output_file', type=argparse.FileType('w'), nargs='?', default=sys.stdout)
    args = parser.parse_args()

    make_template(args.input_file, args.output_file)

