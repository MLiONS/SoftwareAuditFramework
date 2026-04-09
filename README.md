# Software Audit Framework
This framework is designed to facilitate a comprehensive audit of software systems to ensure compliance, security, and efficiency. The audit process includes several key steps:

## Physical Inspection
Conducting physical inspections of systems is essential to ensure that no unauthorized devices or hardware are connected to the network. This step helps in identifying potential security breaches and ensuring that the system is in compliance with organizational policies and regulations.

## Vulnerability Assessment (VA)
Performing a vulnerability assessment is a crucial step in identifying and mitigating potential security risks within software systems. This process involves scanning the system for known vulnerabilities and weaknesses that could be exploited by attackers. VA helps in prioritizing and addressing security issues effectively.

## Static Application Security Testing (SAST)
SAST involves analyzing the source code or binary of an application to identify and eliminate security vulnerabilities early in the development process. This step helps in ensuring that the software is secure and free from common security flaws such as SQL injection, cross-site scripting (XSS), and buffer overflows.

## System Fingerprinting
### What is Fingerprinting?
System fingerprinting is the process of collecting and identifying various characteristics and details about a system. This includes hardware details, software configurations, network settings, and other system-specific information. The collected data forms a unique "fingerprint" of the system, which can be used for various purposes such as monitoring, security, compliance, and troubleshooting.

### Why is Fingerprinting Important?
**Security:** Fingerprinting helps in identifying unauthorized changes or potential security breaches. By comparing the current fingerprint with a known good state, discrepancies can be quickly identified.

**Compliance:** Many industries have regulations that require detailed documentation of system configurations. Fingerprinting automates this process, ensuring that all necessary information is collected and stored.

**Troubleshooting:** When issues arise, having a detailed fingerprint of the system can help in diagnosing problems faster by providing a clear view of the system's state at various points in time.

**Monitoring:** Regular fingerprinting can help in monitoring the health and performance of a system, enabling proactive maintenance and avoiding potential downtimes.

### Linux — `System_Fingerprint_Linux.sh`
A shell script that collects detailed information about the system's hardware, software, and network configuration and saves the output to `system_fingerprint.txt`. Run with `sudo ./System_Fingerprint_Linux.sh`.

### Windows — `Vajra_Fingerprint_Tool_Text.exe`
A Windows executable that generates a system fingerprint report in text format. Right-click and select **Run as Administrator**, choose the output location, and click **Save**. The report is saved as `system_fingerprint.txt`.

## File Integrity Scanner — `File_Integrity_Scanner`
A lightweight Linux executable that automates integrity verification of files within a directory. Run it directly with `./File_Integrity_Scanner`.

The tool recursively traverses all folders and subfolders and generates a hash value for every file it finds. It produces two CSV files — one with detailed per-file information (path, hash, extension, last modified) and another with a summary of the scan. It also displays useful statistics such as total file count, file-type breakdown, and total size. This makes it straightforward to verify file integrity, track changes, and audit the contents of a directory.
