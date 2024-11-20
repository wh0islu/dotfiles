import tkinter as tk
from tkinter import ttk
import time
import csv
from datetime import datetime


class Timer:
    def __init__(self, master):
        self.master = master
        self.master.title("Tarefa e Timer")

        self.timer_running = False
        self.start_time = 0
        self.elapsed_time = 0

        ttk.Label(master, text="Tarefa:").grid(row=0, column=0, padx=5, pady=5)
        self.task_entry = ttk.Entry(master, width=20)
        self.task_entry.grid(row=0, column=1, padx=5, pady=5)

        self.start_button = ttk.Button(master, text="Iniciar", command=self.start_timer)
        self.start_button.grid(row=1, column=0, padx=5, pady=5)
        self.stop_button = ttk.Button(master, text="Parar", command=self.stop_timer)
        self.stop_button.grid(row=1, column=1, padx=5, pady=5)

        self.timer_label = ttk.Label(master, text="00:00:00", font=("Helvetica", 24))
        self.timer_label.grid(row=2, column=0, columnspan=2, padx=5, pady=5)

    def start_timer(self):
        if not self.timer_running:
            self.timer_running = True
            self.start_time = time.time() - self.elapsed_time
            self.update_timer()

    def stop_timer(self):
        if self.timer_running:
            self.timer_running = False
            task = self.task_entry.get()
            if task:
                self.save_task(task, self.elapsed_time)
            self.elapsed_time = 0
            self.timer_label.config(text="00:00:00")

    def update_timer(self):
        if self.timer_running:
            self.elapsed_time = time.time() - self.start_time
            hours, rem = divmod(self.elapsed_time, 3600)
            minutes, seconds = divmod(rem, 60)
            self.timer_label.config(text="{:0>2}:{:0>2}:{:05.2f}".format(int(hours), int(minutes), seconds))
            self.master.after(10, self.update_timer)

    def save_task(self, task, duration):
        hours, rem = divmod(int(duration), 3600)
        minutes, seconds = divmod(rem, 60)
        time_format = f"{hours:02d}:{minutes:02d}:{seconds:02d}"

        with open('tasks.csv', mode='a', newline='') as file:
            writer = csv.writer(file)
            writer.writerow([task, time_format, datetime.now().strftime("%Y-%m-%d %H:%M:%S")])


if __name__ == "__main__":
    root_tk = tk.Tk()
    app = Timer(root_tk)
    root_tk.mainloop()
