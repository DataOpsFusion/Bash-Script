#!/bin/bash
echo "This script will attempt to install a virutal machine"
echo "You want to continue? (y/n)"
read response


if [[$response == 'n']]; then
    echo "Exiting..."
elif [[$response == 'y']]; then
    echo "Please provide the url to the file or i will try to use the default url (local/remote)"
    read url
    if [[$url == 'local']]; then
        get_local_file
    elif [[$url == 'remote']]; then
        get_remote_file
    else
        echo "Invalid input"
    fi


    echo "Exiting..."
else
    echo "Invalid input"
fi

get_local_file() {
    echo "Please provide the path of the file: "
    read path

      
        echo "File or directory does not exist"
        exit 1
    fi

    # Count ISO files
    iso_count=$(ls "$path" | grep -i '\.iso$' | wc -l)

    if [[ $iso_count -eq 0 ]]; then
        echo "No ISO file found in $path"
        exit 1
    elif [[ $iso_count -gt 1 ]]; then
        echo "Multiple ISO files found:"
        ls "$path" | grep -i '\.iso$'
        echo "Please enter the filename to use:"
        read file
        full_path="$path/$file"
        if [[ ! -f "$full_path" ]]; then
            echo "File does not exist: $full_path"
            exit 1
        fi
        echo "$full_path"
    else
        # Only one .iso found, auto-select it
        file=$(ls "$path" | grep -i '\.iso$')
        echo "$path/$file"
    fi
}

get_remote_file(){
    echo "Please provide the URL of the file: "
    read url
    wget -q --spider $url
    if [[ $? -ne 0 ]]; then
        echo "URL does not exist"
        exit 1
    else 
        wget -q $url
        mv $(basename $url) /var/lib/libvirt/images/
        echo "/var/lib/libvirt/images/$(basename $url)"
    fi
}

install_vm(){
    name=${name:-"vm1"}
    ram=${ram:-"2048"}
    vcpus=${vcpu:-"2"}
    
    virt-install
    --virt-type kvm
    --name $name
    --disk path=/var/lib/libvirt/images/$file,size=10
    --ram $ram
    --vcpus $vcpus
    --os-type linux
    --network bridge=virbr0
    --graphics none
    --console pty,target_type=serial
    --location $file
    --extra-args 'console=ttyS0,115200n8 serial'    
}

get_input(){
    echo "$1"
    read $2

}