#!/usr/bin/env python3

import argparse

def parse_args():
    parser = argparse.ArgumentParser(
        description='Pass commands to run and then email the std out and std error to an email specificed in the config.')
    parser.add_argument("commands", nargs='+',
        help = "A list of commands that will be ran in order.")
    args = parser.parse_args()
    return args

def parse_config():
    pass


def main():
    args=parse_args()
    print(args.commands)

if __name__ == "__main__":
    # execute only if run as a script
    main()