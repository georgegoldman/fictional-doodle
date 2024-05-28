# Keyboard Event Detection in Linux with Flutter and Dart FFI

This repository demonstrates how to detect keyboard events in a Linux environment using C, create a shared library from this C code, and integrate it with a Flutter application using Dart FFI. It also includes functionality to control the interval for checking keyboard events from the Dart side.

## Prerequisites

1. Basic knowledge of C programming.
2. Familiarity with Flutter and Dart.
3. A Linux environment for compiling and running the code.

## Features

- Detects keyboard events on a specified device in Linux.
- Provides a C-based shared library (libkeyboard_event.so).
- Integrates the shared library with Flutter using Dart FFI.
- Allows dynamic control of the interval for keyboard event status checks from Dart.

## Getting Started

### Step 1: Writing the C Code

The C program detects keyboard events using the Linux input event interface. It is compiled into a shared library to be used in a Flutter application.


#### Header File (`dx.h`)

```c
#ifndef KEYBOARD_EVENT_H
#define KEYBOARD_EVENT_H

#include <stdbool.h>

// Initializes the keyboard event handling thread
void init_keyboard_event(const char *device);

// Stops the keyboard event handling thread
void stop_keyboard_event(void);

// Gets the current value of the keyboard event status
bool get_keyboard_event_status(void);

// Sets the interval for the keyboard event status check
void set_event_check_interval(int interval);

#endif // KEYBOARD_EVENT_H

```

### Source File (dx.c)


```
Source File (lib/keyboard_event.c)

#include "keyboard_event.h"
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <linux/input.h>
#include <pthread.h>
#include <stdbool.h>
#include <time.h>

static bool x = false;
static pthread_mutex_t lock;
static int keep_running = 1;
static time_t last_event_time;
static pthread_t thread_id;
static int event_check_interval = 4; // Default interval of 4 seconds

static void *keyboardEvent(void *vargp) {
    const char *device = (const char *)vargp;
    int fd;

    // Open the device file
    fd = open(device, O_RDONLY);
    if (fd == -1) {
        perror("Error opening device file");
        return NULL;
    }

    // Set the initial event time
    pthread_mutex_lock(&lock);
    last_event_time = time(NULL);
    pthread_mutex_unlock(&lock);

    struct input_event ev;
    while (keep_running) {
        // Read an input event
        ssize_t n = read(fd, &ev, sizeof ev);
        if (n == (ssize_t)-1) {
            perror("Error reading event");
            close(fd);
            return NULL;
        } else if (n != sizeof ev) {
            fprintf(stderr, "Unexpected event size\n");
            close(fd);
            return NULL;
        }

        // Process the event
        if (ev.type == EV_KEY) {
            pthread_mutex_lock(&lock);
            last_event_time = time(NULL); // Update the last event time
            x = true; // Set x to true on any key event
            pthread_mutex_unlock(&lock);
        }
    }

    close(fd);
    return NULL;
}

void init_keyboard_event(const char *device) {
    if (pthread_mutex_init(&lock, NULL) != 0) {
        perror("Mutex init failed");
        exit(EXIT_FAILURE);
    }

    keep_running = 1;

    pthread_create(&thread_id, NULL, keyboardEvent, (void *)device);
}

void stop_keyboard_event(void) {
    keep_running = 0;
    pthread_join(thread_id, NULL);
    pthread_mutex_destroy(&lock);
}

bool get_keyboard_event_status(void) {
    pthread_mutex_lock(&lock);
    time_t current_time = time(NULL);
    if (difftime(current_time, last_event_time) > event_check_interval) {
        x = false;
    }
    bool status = x;
    pthread_mutex_unlock(&lock);
    return status;
}

void set_event_check_interval(int interval) {
    pthread_mutex_lock(&lock);
    event_check_interval = interval;
    pthread_mutex_unlock(&lock);
}

```

### Step 2: Compiling the Shared Library

Compile the C code into a shared library that can be used by the Flutter application.

```
gcc -shared -o libkeyboard_event.so -fPIC lib/keyboard_event.c -lpthread
```

### Step 3: Use the Dart FFI Wrapper

### Step 4: Running the Application

```

flutter run
```

### Repository Structure

```
.
├── library
│   └── linux
│       ├── libkeyboard_event.so
│       ├── librandomnumber.so
│       └── libstringops.so
├── main.dart
└── shared
    └── services
        └── ffi
            └── ffi.service.dart

6 directories, 5 files

```
