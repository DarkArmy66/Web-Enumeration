#!/bin/bash

# digdomain.sh - Automated Website Reconnaissance Script
# Author: [0xproxychains]
# GitHub: [darkarmy66]

# Function to print section headers
print_section() {
    echo -e "\n\033[1;34m[+] $1\033[0m"
    echo "----------------------------------------"
}

# Function to run a command and display its output
run_cmd() {
    echo -e "\033[1;32m[*] Executing: $1\033[0m"
    eval "$1"
    echo ""
}

# Prompt for input
read -p "Enter a domain or IP address: " input

# Check if input is an IP or domain
if [[ $input =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    type="IP"
else
    type="domain"
fi

# WHOIS Information
print_section "WHOIS Information"
run_cmd "whois $input"

# DNS Information
print_section "DNS Information"

echo -e "\n--- Default A Record Lookup ---"
run_cmd "dig $input"

echo -e "\n--- Address Record (A) ---"
run_cmd "dig $input A"

echo -e "\n--- IPv6 Address Record (AAAA) ---"
run_cmd "dig $input AAAA"

echo -e "\n--- Mail Exchange Record (MX) ---"
run_cmd "dig $input MX"

echo -e "\n--- Name Server Record (NS) ---"
run_cmd "dig $input NS"

echo -e "\n--- Text Record (TXT) ---"
run_cmd "dig $input TXT"

echo -e "\n--- Canonical Name Record (CNAME) ---"
run_cmd "dig $input CNAME"

echo -e "\n--- Start of Authority Record (SOA) ---"
run_cmd "dig $input SOA"

echo -e "\n--- Using Specific Name Server (1.1.1.1) ---"
run_cmd "dig @$1.1.1.1 $input"

echo -e "\n--- Full Path of DNS Resolution (+trace) ---"
run_cmd "dig +trace $input"

if [[ $type == "IP" ]]; then
    echo -e "\n--- Reverse Lookup (PTR) ---"
    run_cmd "dig -x $input"
else
    echo -e "\n--- Short Answer ---"
    run_cmd "dig +short $input"

    echo -e "\n--- Answer Section Only (+noall +answer) ---"
    run_cmd "dig +noall +answer $input"

    echo -e "\n--- All Available DNS Records (ANY) ---"
    run_cmd "dig $input ANY"
fi

# Zone Transfer Attempt
print_section "Zone Transfer Attempt"
for ns in $(dig +short ns $input); do
    echo -e "\nAttempting zone transfer on nameserver: $ns"
    run_cmd "dig axfr $input @$ns"
done

