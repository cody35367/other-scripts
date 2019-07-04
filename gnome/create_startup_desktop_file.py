#!/usr/bin/env python3
import os,argparse,gen_desktop_file

def get_args():
    parser = argparse.ArgumentParser(
        description="A tool that will generates a .desktop file for standalone executable and put it in the startup application location. This will cause the executable to effectively launch on login.")
    parser.add_argument("executable",
        help="The standalone executable that will be ran by the desktop file.")
    return parser.parse_args()

def main():
    args=get_args()
    desktop_filename=".".join(os.path.basename(args.executable).split(".")[:-1])+".desktop"
    output_file=os.path.join(os.getenv("HOME"),".config","autostart",desktop_filename)
    gen_desktop_file.gen_desktop_file(args.executable,output_file)

if __name__ == "__main__":
    main()