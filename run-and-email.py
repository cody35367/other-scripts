#!/usr/bin/env python3

import argparse,subprocess,shlex

def parse_args():
    parser = argparse.ArgumentParser(
        description='Pass commands to run and then email the std out and std error to an email specificed in the config.')
    parser.add_argument("commands", nargs='+',
        help = "A list of commands that will be ran in order.")
    args = parser.parse_args()
    return args

def parse_config():
    pass

def run(commands):
    for command in commands:
        command_list=shlex.split(command)
        result=subprocess.run(command_list,capture_output=True,text=True)
        print("Command: "+command)
        print("Command list: "+str(command_list))
        print("Returncode: "+str(result.returncode))
        print("Stdout: \n"+result.stdout)
        print("Stderr: \n"+result.stderr)
        print("\n=========================================================")

def main():
    args=parse_args()
    run(args.commands)

if __name__ == "__main__":
    # execute only if run as a script
    main()