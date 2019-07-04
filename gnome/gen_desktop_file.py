#!/usr/bin/env python3
import os,argparse,stat
from string import Template

DEFAULT_DESKTOP_FILE_VALS={
    "NAME":"",
    "EXEC":"",
    "TERMINAL":"false",
    "TYPE":"Application"
}
TEMPLATE_FILE=os.path.join(os.path.dirname(os.path.realpath(__file__)),"desktop-file.template")

def gen_desktop_file(executable,output_file):
    DEFAULT_DESKTOP_FILE_VALS["NAME"]=".".join(os.path.basename(executable).split(".")[:-1])
    DEFAULT_DESKTOP_FILE_VALS["EXEC"]=os.path.realpath(executable)
    desktop_file_contents=""
    with open(TEMPLATE_FILE,'r') as f:
        desktop_file_contents=Template(f.read()).safe_substitute(DEFAULT_DESKTOP_FILE_VALS)
    with open(output_file,'w') as f:
        f.write(desktop_file_contents)
    os.chmod(output_file,os.stat(output_file).st_mode|stat.S_IXUSR)
    print("Created: "+output_file)

def get_args():
    parser = argparse.ArgumentParser(
        description="A tool that will generates a .desktop file for standalone executable.")
    parser.add_argument("executable",
        help="The standalone executable that will be ran by the desktop file.")
    parser.add_argument("output_file",
        help="The output file.")
    return parser.parse_args()

def main():
    args=get_args()
    gen_desktop_file(args.executable,args.output_file)

if __name__ == "__main__":
    main()