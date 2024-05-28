# Keyboard Event Detection in Linux with Flutter and Dart FFI

This repository demonstrates how to detect keyboard events in a Linux environment using C, create a shared library from this C code, and integrate it with a Flutter application using Dart FFI. It also includes functionality to control the interval for checking keyboard events from the Dart side.

## Prerequisites

1. Basic knowledge of C programming.
2. Familiarity with Flutter and Dart.
3. A Linux environment for compiling and running the code.

## Getting Started

### Step 1: Writing the C Code

The C program detects keyboard events using the Linux input event interface. It is compiled into a shared library to be used in a Flutter application.
