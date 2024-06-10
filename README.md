#Software Audit Framework
This framework is designed to facilitate a comprehensive audit of software systems to ensure compliance, security, and efficiency. The audit process includes several key steps:

##Physical Inspection
Conducting physical inspections of systems is essential to ensure that no unauthorized devices or hardware are connected to the network. This step helps in identifying potential security breaches and ensuring that the system is in compliance with organizational policies and regulations.

##Vulnerability Assessment (VA)
Performing a vulnerability assessment is a crucial step in identifying and mitigating potential security risks within software systems. This process involves scanning the system for known vulnerabilities and weaknesses that could be exploited by attackers. VA helps in prioritizing and addressing security issues effectively.

##Static Application Security Testing (SAST)
SAST involves analyzing the source code or binary of an application to identify and eliminate security vulnerabilities early in the development process. This step helps in ensuring that the software is secure and free from common security flaws such as SQL injection, cross-site scripting (XSS), and buffer overflows.

## System Fingerprinting
### What is Fingerprinting?
System fingerprinting is the process of collecting and identifying various characteristics and details about a system. This includes hardware details, software configurations, network settings, and other system-specific information. The collected data forms a unique "fingerprint" of the system, which can be used for various purposes such as monitoring, security, compliance, and troubleshooting.

### Why is Fingerprinting Important?
Security: Fingerprinting helps in identifying unauthorized changes or potential security breaches. By comparing the current fingerprint with a known good state, discrepancies can be quickly identified.

Compliance: Many industries have regulations that require detailed documentation of system configurations. Fingerprinting automates this process, ensuring that all necessary information is collected and stored.

Troubleshooting: When issues arise, having a detailed fingerprint of the system can help in diagnosing problems faster by providing a clear view of the system’s state at various points in time.

Monitoring: Regular fingerprinting can help in monitoring the health and performance of a system, enabling proactive maintenance and avoiding potential downtimes.

###  Usage Instructions
#### Linux
Clone the Repository
```bash
git clone https://github.com/MLiONS/SoftwareAuditFramework
```
```bash
cd SoftwareAuditFramework

cd Linux
```
Grant Execution Permissions

Before running the script, you need to give it execution permissions.

This can be done using the following command:
```bash
chmod +x system_fingerprint_linux.sh
```
Run the Script

Execute the script to generate a fingerprint of your system:
```bash
./system_fingerprint_linux.sh
```
Output

The script will generate a report with detailed information about your system's hardware, software, and network configurations. The output will be saved in a file named system_fingerprint.txt.

#### Windows

Clone the Repository
```bash
git clone https://github.com/MLiONS/SoftwareAuditFramework
```
```bash
cd SoftwareAuditFramework

cd Windows
```

Set Execution Policy

Before running the PowerShell script, you need to set the execution policy to allow script execution.

This can be done using the following command:
```bash
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

Run the Script

Execute the PowerShell script to generate a fingerprint of your system:

```bash
.\system_fingerprint_windows.ps1
```

Output

The script will generate a report with detailed information about your system's hardware, software, and network configurations. The output will be saved in a file named system_fingerprint.txt.
