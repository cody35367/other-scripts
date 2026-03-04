# Host/IP Tracker

- On central server with know IP: `./host-tracker`
- On Linux client: `/path/to/host-tracker-client localhost 9537`
- On Windows client: `C:\path\to\python.exe C:\path\to\host-tracker-client localhost 9537`
- All this assume hostnames are unique.

# Schedule

- Linux
    - `crontab -e`
    - `*/5 * * * * /path/to/host-tracker-client localhost 9537`
- Windows
    - Setup in Task Scheduler
    - In the right panel, click Create Task… (not “Create Basic Task”).
        - General Tab:
            - Name: Python Check-in Client
            - Run As system
        - Go to Triggers tab → New…
            - Begin the task: On a schedule
                - Daily, repeat every 1 day
                - Check Repeat task every: 5 minutes
                - For a duration: Indefinitely
                - Click OK
        - Go to Actions tab → New…
            - Action: Start a program
                - Program/script: path to Python 3 executable, e.g.: C:\path\to\python.exe
                - Add arguments: the path to your script + server + port, e.g.: C:\path\to\host-tracker-client localhost 9537
        - Go to Settings tab:
            - “Allow task to be run on demand” → check
            - “Stop task if it runs longer than …” → optional
