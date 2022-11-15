# FoodViewer
FoodViewer - Clean Architecture Reference (TDD, Snapshots, Linting, Formatting)

# Clean ReferenceArchitectureNonModularServer

This is a simple Vapor Web Service that returns the details and list of all foods (data from https://github.com/heydenberk/gardening-data). You are able to edit and run the project using the `open Package.swift` command inside of the folder. Update the working directory in the schema to the location where the Package.swift is located and it should all work fine.

It has two endpoints:

GET: /foods

GET: /foods/details/:identifier

# Clean ReferenceArchitectureNonModular

This is a simple application that loads the food list and allows filtering of the food data as well as seeing some details about the specific food. It is used as a reference for setting up an iOS project in a small to medium sized team (5-10 engineers in total organisation).

The application is split into 4 distinct layers and a fifth layer for Unit/Integration/Snapshot testing. These layers are App, Data, Domain and UI (and  CommonUI). The connectedness and the components are depicted in the diagram below and are created using Swift Packages for building the layers as well as managing dependencies.

<img width="900" alt="Connected" src="https://user-images.githubusercontent.com/1991747/201959374-70ae0a6f-ca39-4ecb-a05e-e74f8e830837.png">

## Style & Code Quality

Linting and source code formatting is done using Swiftlint (https://github.com/realm/SwiftLint) & SwiftFormat (https://github.com/nicklockwood/SwiftFormat) and by running the lint-format.sh script inside of the SRCROOT.

## Unit, Integration & Snapshot Testing

Unit Testing is done for each layer in the TestingLayer Swift Package using standard XCTest and the AAA TDD approach. Mocking of network requests is done by using Mocker (https://github.com/WeTransfer/Mocker)
