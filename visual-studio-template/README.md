visual-studio-template
======================

Visual Studio project props common build scenarios.

These props files can be integrated into a Visual Studio `.vcxproj` file as follows:

```xml
  <ImportGroup Label="PropertySheets" Condition="'$(Configuration)|$(Platform)'=='DebugDLL|Win32'">
    <Import Project="$(ProjectDir)..\..\properties\DebugDLL.props" />
    <Import Project="$(ProjectDir)..\..\properties\Output.props" />
    <Import Project="$(ProjectDir)$(ProjectName).props" />
  </ImportGroup>
```

A simpler (recommended) approach is to align Configuration names with the .`props` file names. This collapses to one `ImportGroup`, as follows:

```xml
  <ImportGroup>
    <Import Project="$(ProjectDir)..\..\properties\$(Configuration).props" />
    <Import Project="$(ProjectDir)..\..\properties\Output.props" />
    <Import Project="$(ProjectDir)$(ProjectName).props" />
  </ImportGroup>
```

The `$(ProjectName).props` file is your file containing all unique properties for the project. Generally this is the set of includes, library references, preprocessor statements and warning overrides.

The optional `Output.props` file changes the default Visual Studio build output locations to common `bin` and `obj` folders, ensures deconfliction across all builds and writes certain build information to the console.

There is generally no good reason to change the `.props` files as overrides are possible within `$(ProjectName).props`. However if one desires to change the outputs the `Output.props` file can be independently dropped or replaced.

Note that all `.props' files are assumed to be in a common directory, despite the repo structure.

The following combinations are achieved by referencing the desired build configuration (e.g. `DynamicDLL.props`) as shown above.

**Dynamic libraries linked dynamically to CRT**
```
DebugDLL|Win32
ReleaseDLL|Win32
DebugDLL|x64
ReleaseDLL|x64
```
**Static libraries linked using LTCG and statically to CRT**
```
DebugLTCG|Win32
ReleaseLTCG|Win32
DebugLTCG|x64
ReleaseLTCG|x64
```
**Static libraries linked statically to CRT**
```
DebugLIB|Win32
ReleaseLIB|Win32
DebugLIB|x64
ReleaseLIB|x64
```
**Applications linked dynamically to CRT**
```
DebugDEXE|Win32
ReleaseDEXE|Win32
DebugDEXE|x64
ReleaseDEXE|x64
```
**Applications linked using LTCG and statically to CRT**
```
DebugLEXE|Win32
ReleaseLEXE|Win32
DebugLEXE|x64
ReleaseLEXE|x64
```
**Applications linked statically to CRT**
```
DebugSEXE|Win32
ReleaseSEXE|Win32
DebugSEXE|x64
ReleaseSEXE|x64
```
