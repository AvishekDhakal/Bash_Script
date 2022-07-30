#! /bin/bash
function main (){

echo "This is a script for encryption and decryption. Choose what you want to do below"
echo " "
echo -n "[+]Please type 'e' for Encryption 'd' for Decrpytion and 'exit' to Exit: " 
read answer1 
    
#functions
function path(){
    echo "Pleae specify the direcotry you need to work on(absolute path)"
    echo "You can press 'c' to use you current directory ($(pwd))"
    read path
    if [ -d "$path" ]; then 
        cd $path 
        echo " "
        ls $path 
    elif [[ "$path" == "c" || "$path" == "current" ]]; then 
        ls $(pwd)
    else 
        echo "Path Incorrect!"
        echo "Please provide correct path"
        echo " "
        path
    fi        
    echo " " 
}

function symmetric_enc (){
    echo " "
    echo "The above contents will be encrpyted."
    echo "Specify the algorith you want to use"
    echo "des , base64 , aes-128-cbc ....."
    read algorithm1
    if [ -n "$algorithm1" ]; then 
      echo "Specify the encrytped filename:"
      read output_file1
      if [ -n "$output_file1" ]; then
        openssl $algorithm1 -e -in $1 -out $output_file1 
        echo "encrpyting..."
        # sleep 3
        echo "Successfully! encrypted"
      else 
        echo "File error"
        symmetric_enc
      fi
    
    else
        echo "Field Empty!"
        symmetric_enc
    fi
}

function asymmetric_enc (){
    echo " "
    echo "The above contents will be encrpyted."
    echo "Genreating private key..."
    openssl genrsa -out rsa_private_key.pem 1024
    sleep 2
    echo "Genreating public key..."
    openssl rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem
    sleep 2
    echo "Specify the encrytped filename:"
    read output_file2
    if [ -n "$output_file2" ]; then
      echo "encrypting with public key..."
      openssl rsautl -encrypt -in $1 -inkey rsa_public_key.pem -pubin -out $output_file2 
      sleep 4
      echo "Successfully! encrypted"
    else 
      echo "Input Invalid!"
      asymmetric_enc
    fi

}
function symmetric_dec (){
    echo " "
    echo "Please specify the file for decryption"
    read file_name2
    if [[ -r "$file_name2" && -n "$file_name2" ]]; then 
    	echo "Specify the algorithm used"
    	read algorithm2 
    	echo "Finally specify the output name"
    	read output_file3
    	echo "decrypting.."
    	openssl $algorithm2 -d -in $file_name2 -out $output_file3
        if [ $? == 0  ]; then
            sleep 3
            echo "Successfully Decrypted!"
            echo " "
            echo "Below is the decrypted content"
            cat $output_file3
        else 
            echo " "
            echo "Something went wrong with password or algorithm.Try Again"
            echo " "
        symmetric_dec 
        fi
        
    
    else 
    	echo "Make sure file exists with read permission."
    	echo " "
    	symmetric_dec
    fi
}

function asymmetric_dec (){
    echo " "
    echo "Please specify the file for decryption"
    read file_name4
    if [[ -r "$file_name4" && -n "$file_name4" ]]; then 
    	echo "Decrypting.."
    	openssl rsautl -decrypt -in $file_name4 -inkey rsa_private_key.pem -out asdec.de
        sleep 3
        echo "Successfully Decrypted!"
        echo " "
        echo "Below is the decrypted content"
        cat asdec.de
    
    else 
    	echo "Make sure file exists with read permission."
    	asymmetric_dec
    fi

}


if [[ "$answer1" == "e" || "$answer1" == "encryption" || "$answer1" == "enc" || "$answer1" == "Encryption" ]]; then
    echo "Do you want to encrpty an existing file (y/n): "
    read answer2
    if [[ "$answer2" == "y" || "$answer2" == "yes"|| "$answer2" == "Yes" ]]; then
        echo "Asymmetric encrption or Symmetric encrption(a/s): "
        read answer3
        
        if [[ "$answer3" == 's' || "$answer3" == "symmetric" || "$answer3" == "sy" || "$answer3" == "Symmetric" ]]; then
            path
            echo "Please enter the File name"
            read file_name1
            echo " "
            if [[ -n "$file_name1" && -r "$file_name1" ]]; then
		          cat $file_name1
		          echo " " 
            	symmetric_enc "$file_name1"
            else 
            	echo "Filename Error"
                echo "Please try again"
                echo " "
                main
            fi

        elif [[ $answer3 == 'a' || "$answer3" == "asymmetric" || "$answer3" == "Asymmetric" || "$answer3" == "as" ]]; then 
            path
            echo "please enter the File name"
            read file_name6
            if [[ -n "$file_name6" && -r $file_name6 ]]; then 
                cat $file_name6
                echo " "
                asymmetric_enc "$file_name6"
            else 
            	echo "Filename Error"
                echo "Please try again"
                echo " "
                main
            fi

        else 
            echo "Invlaid option"
            echo "Please Try Again"
            echo " "
            main
        fi    
    
    elif [[ "$answer2" == "n" || "$answer2" == "no" || "$answer2" == "No" ]]; then
        path
    	echo "Please specify the new filename"
    	read file_name5 
        if [ -n "$file_name5" ]; then 
            echo "Please type the content for your new file($file_name5)"
            read content
            echo $content > $file_name5
            echo "Asymmetric encrption or Symmetric encrption(a/s): "
            read answer3
            if [[ "$answer3" == "s" || "$answer3" == "symmetric" || "$answer3" == "sy" || "$answer3" == "Symmetric" ]]; then
                symmetric_enc "$file_name5"
            
            elif [[ "$answer3" == "a" || "$answer3" == "asymmetric" || "$answer3" == "Asymmetric" || "$answer3" == "as" ]]; then
                asymmetric_enc "$file_name5"
            
            else
                echo " "
                echo "Invlaid option"
                echo " "
                main
            fi  
        else 
            echo " You cannot leave filename empty."
            main  
        fi
    
    else 
        echo "Invalid option"
        echo "Please try again"
        echo " "
        main
    fi 

elif [[ $answer1 == "d" || "$answer1" == "dec" || "$answer1" == "decryption" ]]; then 
    echo "Specify asymmetric decryption or symmetric decryption(a/s): "
    read answer4
    if [[ "$answer4" == 's' || "$answer4" == "symmetric" || "$answer4" == "sy" || "$answer4" == "Symmetric" ]]; then
        path
        symmetric_dec
    
    elif [[ "$answer4" == "a" || "$answer4" == "asymmetric" || "$answer4" == "Asymmetric" || "$answer4" == "as" ]]; then 
        path
        asymmetric_dec
        
    
    else 
        echo "Invalid option"
        echo "Please try again"
        echo " "
        main
    fi

elif [[ "$answer1" == "exit" || "$answer1" == "Exit" ]]; then 
    echo "Bye Bye "
    exit 0

else 
    echo " "
    echo "Invalid option"
    echo "Please try again"
    echo " "
    main
fi 


function resume(){
echo " "
echo "Do you want to use it again?(y/n)"
read main_answer

if [[ "$main_answer" == "y" || "$main_answer" == "yes" || "$main_answer" == "Yes" ]]; then
    sleep 1
    main

elif [[ "$main_answer" == "n" || "$main_answer" == "no" || "$main_answer" == "No" ]]; then
    sleep 1
    echo "Bye Bye"
    exit 0

else
    echo "Invalid option! Please try again."
    resume
fi
}
resume
}
main


