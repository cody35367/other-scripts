#!/usr/bin/env python3

import argparse,subprocess,shlex,smtplib,traceback,os,configparser

DEBUG=False
DEFAULT_EMAIL_FORMAT = """\
From: %s
To: %s
Subject: %s

%s
"""

CONFIG_FILE_NAME="run-and-email.ini"
CONFIG_FILE_PATH=os.path.join(os.path.dirname(os.path.realpath(__file__)),CONFIG_FILE_NAME)

def parse_args():
    parser = argparse.ArgumentParser(
        description='Pass commands to run and then email the std out and std error to an email specificed in the config.')
    parser.add_argument("commands", nargs='+',
        help = "A list of commands that will be ran in order.")
    parser.add_argument("-s", "--subject", required=True,
        help = "The subject the sent email will have.")
    parser.add_argument("-t", "--to", required=True,
        help = "Email to send the email to. Can specify multiple with a comma.")
    parser.add_argument("-v", "--verbose", action='store_true',
        help = "A verbose output mode for debuging.")
    args = parser.parse_args()
    return args

def parse_config():
    config = configparser.ConfigParser()
    config.read(CONFIG_FILE_PATH)
    return config

def run(commands):
    results=[]
    for command in commands:
        single_res={}
        command_args=shlex.split(command)
        result=subprocess.run(command_args,capture_output=True,text=True)
        single_res["command"]=command
        single_res["command_args"]=str(command_args)
        single_res["returncode"]=str(result.returncode)
        single_res["stdout"]=result.stdout
        single_res["stderr"]=result.stderr
        results.append(single_res)
    return results

def print_cmd(results):
    print(create_email_body(results))

def create_email_body(results):
    rstr=""
    for result in results:
        rstr+=(
            "Command: "+result["command"]+"\n"+
            "Command args: "+result["command_args"]+"\n"+
            "Returncode: "+result["returncode"]+"\n"+
            "Stdout: \n"+result["stdout"]+"\n"+
            "Stderr: \n"+result["stderr"]+"\n"+
            "===========================================================\n")
    return rstr

def email(server,username,password,to,subject,results):
    body=create_email_body(results)
    msg=DEFAULT_EMAIL_FORMAT % (username, ", ".join(to), subject, body)
    try:
        smtp=smtplib.SMTP_SSL(server)
        smtp.login(username,password)
        smtp.sendmail(username,to,msg)
        smtp.close()
    except:
        print("Failed to send email!")
        if DEBUG:
            traceback.print_exc()
        

def run_and_email(commands,server,username,password,to,subject):
    results=run(commands)
    if DEBUG:
        print_cmd(results)
    email(server,username,password,to,subject,results)

def main():
    global DEBUG #Needed to update this var
    args=parse_args()
    if args.verbose:
        DEBUG=True
    config=parse_config()
    run_and_email(args.commands,config["email"]["SMTP_SERVER"],
        config["email"]["SMTP_USER"],config["email"]["SMTP_PASSWORD"],
        args.to.split(","),args.subject)    

if __name__ == "__main__":
    # execute only if run as a script
    main()