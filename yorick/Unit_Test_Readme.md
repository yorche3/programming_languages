
# Unit Test projects with dotnet and Fsharp with Nunit
How were built unit test projects.

## Requisites
- Install
  - [F#](https://fsharp.org/)
  - D
dotnet

## Structure
```text
demo
|--- lib
|    |--- lib.fsproj
|--- tests
     |--- tests.fsproj
```

## Configure
- Initialize going to your demo dir and run:
  - for your lib subproject
```bash
dotnet new classlib -lang "F#" -o lib
```
  - for your test subproject
```bash
dotnet new nunit -lang "F#" -o tests
```

## Build project
- In your demo dir
```bash
donet add tests reference lib
```
- and update oyur dependencies from your subprojects
```bash
donet build
```

## Modify project
- In your `tests.fsproj` add the code and modifications similar to following:
```nuget
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>

    <IsPackable>false</IsPackable>
    <GenerateProgramFile>false</GenerateProgramFile>
    <IsTestProject>true</IsTestProject>
  </PropertyGroup>

  <ItemGroup>
    <ProjectReference Include="..\lib\lib.fsproj" />
  </ItemGroup>
  
  <ItemGroup>
    <Compile Include="UnitTest1.fs" />
    <Compile Include="Example1Test.fs" />
    <Compile Include="Example2Test.fs" />
  </ItemGroup>

  <ItemGroup>
    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.6.0" />
    <PackageReference Include="NUnit" Version="3.13.3" />
    <PackageReference Include="NUnit3TestAdapter" Version="4.2.1" />
    <PackageReference Include="NUnit.Analyzers" Version="3.6.1" />
    <PackageReference Include="coverlet.collector" Version="6.0.0" />
  </ItemGroup>

</Project>
```
## Compile and run tests
### Compile
### Test
- In your tests subproject
```bash
yorick -batch example_test.yo
```