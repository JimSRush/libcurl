# Get the directory of the current script
$currentDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Define the path to the libcurl DLL with backslashes escaped
$libcurlPath = Join-Path -Path $currentDir -ChildPath "libcurl-4.dll"
$libcurlPath = $libcurlPath.Replace("\", "\\")

# Define the C# code for the functions
$functionCode = @"
using System;
using System.Runtime.InteropServices;

public class CurlFunctionss {
    [DllImport("$libcurlPath", CallingConvention = CallingConvention.Cdecl)]
    public static extern IntPtr curl_easy_init();

    [DllImport("$libcurlPath", CallingConvention = CallingConvention.Cdecl)]
    public static extern int curl_easy_setopt(IntPtr curl, int option, string value);

    [DllImport("$libcurlPath", CallingConvention = CallingConvention.Cdecl)]
    public static extern int curl_easy_perform(IntPtr curl);

    [DllImport("$libcurlPath", CallingConvention = CallingConvention.Cdecl)]
    public static extern void curl_easy_cleanup(IntPtr curl);
}
"@

# Add the type to PowerShell
Add-Type -TypeDefinition $functionCode -Language CSharp

# Now you can use the functions from libcurl
$curlHandle = [CurlFunctionss]::curl_easy_init()
[CurlFunctionss]::curl_easy_setopt($curlHandle, 10002, "http://192.168.178.74/curl") # CURLOPT_URL = 10002
[CurlFunctionss]::curl_easy_perform($curlHandle)
[CurlFunctionss]::curl_easy_cleanup($curlHandle)
