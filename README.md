# IP Info Script

A script for obtaining and analyzing information about IP addresses using the ipinfo.io service.

## Description

This script allows you to get detailed information about a list of IP addresses, including:

- Hostname
- City and region
- Country
- Geographic coordinates
- Provider/organization information
- Postal code
- Time zone

The script processes a list of IP addresses from a file and saves the obtained data in a log file.

## Requirements

- Bash
- curl
- Internet access

## Installation

```bash
git clone <repository-url>
cd <project-directory>
chmod +x ipinfo.sh
```

## Usage

Basic usage:
```bash
./ipinfo.sh ip.txt
```

Using an API token (for extended access):
```bash
./ipinfo.sh ip.txt YOUR_IPINFO_TOKEN
```

Parameters

```text
<ip_file_name> - path to the file with the list of IP addresses (one per line)
[ipinfo_token] - optional parameter, token for the ipinfo.io API
```

## IP Address File Format

The file should contain a list of IP addresses, one address per line:

```
8.8.8.8
1.1.1.1
...
```

## Hostnames File Format
The hostnames.txt file should contain a list of hostnames, separated by |.
```
yandex|google|microsoft
```

## Results

The results are saved in the ipinfo_results.log file in JSON format. The main information is also displayed in the
console during the script execution.
