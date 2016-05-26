# AspnetCore Angular2 Starter Kit

This is a starter kit for working with Angular2 and AspNet core in a packagable and deployable configuration.

## Pre-requisites

In order to run and build the project you need the following:

- [Visual Studio Code](https://code.visualstudio.com/) or [Visual Studio 2015](h9ttps://www.visualstudio.com/en-us/products/visual-studio-community-vs.aspx)
- Node >= 4 (I recommend [Node Version Manager (nvm) for Windows](https://github.com/coreybutler/nvm-windows))
- [Dotnet Core SDK](https://www.microsoft.com/net/core#windows) (If you have VS 2015 you dont need this)

## Quick Start

Clone repo and navigate into it:

```shell
git clone https://github.com/justsayno/aspnet-core-angular2-starter
cd aspnet-core-angular2-starter 
```

*Note all commands from *

Install frontend dependencies:

```shell
cd src/AspnetCoreAngular2Starter.Frontend
npm install
```

Install backend dependencies:

```shell
cd src/AspnetCoreAngular2Starter.MVC
dotnet restore
```

Run the frontend using the command line:

```
npm run start-frontend #Runs a livereloading version of the front end at http://localhost:3000
```

Run the backend from the commandline:

```
npm run start-backend #Runs the backend application at http://localhost:5000 with the scripts pointing at http://localhost:3000
```

Or open project in Visual Studio 2015. In solution explorer open the `src` folder, right click
on the `AspnetCoreAngular2Starter.Mvc` project and select 'Set as Startup Project'. Run the application.


You can now develop the front end application using the http://localhost:3000 url. If you would like to test them together then run
the front end project and the back end project together (in seperate command line windows) and open it at http://localhost:5000

