# ADDRESSBOOK class to put it all together

require "./contact"
require "yaml" # necessary for YAML

class AddressBook
  attr_reader :contacts

  def initialize
    @contacts = []
    open() # open our contact list to start saving to it
  end

  # OPEN and SAVE will save our info to the address book
  def open
    # first check if file exists
    if File.exist?("contacts.yml")
      # assume contacts are present
      # replace contacts array with contents of .yml file
      @contacts = YAML.load_file("contacts.yml") # parses everything in .yml file into Ruby objects
      # replaces the current internal contacts array
    end
  end

  def save
    # We use YAML which is a Ruby library to convert input to text file
    # File.open("filename", "r" || "w" (read or write mode))
    File.open("contacts.yml", "w") do |file| # open in write mode
      file.write(contacts.to_yaml)
    end
  end

  # This run method displays our menu on a loop
  def run
    loop do
      puts "Address Book"
      puts "a: Add Contact"
      puts "p: Print Address Book"
      puts "s: Search"
      puts "e: Exit"
      print "Enter your choice: "
      input = gets.chomp.downcase

      case input
      when 'a'
        add_contact
      when 'p'
        print_contact_list
      when 's'
        print "Search term: "
        search = gets.chomp
        find_by_name(search)
        find_by_phone_number(search)
        find_by_address(search)
      when 'e'
        save() # save contact list before breaking
        break
      end
      puts "\n"
    end
  end

  def add_contact
    contact = Contact.new
    print "First name: "
    contact.first_name = gets.chomp
    print "Middle name: "
    contact.middle_name = gets.chomp
    print"Last name: "
    contact.last_name = gets.chomp

    loop do
      puts "Add phone number or address? "
      puts "p: Add phone number"
      puts "a: Add address"
      puts "(Any other key to go back)"
      response = gets.chomp.downcase

      case response
      when 'p'
        phone = PhoneNumber.new
        print "Phone number kind (Home, Work, etc): "
        phone.kind = gets.chomp
        print "Number: "
        phone.number = gets.chomp
        contact.phone_numbers.push(phone)
      when 'a'
        address = Address.new
        print "Address Kind (Home, Work, etc.): "
        address.kind = gets.chomp
        print "Address line 1: "
        address.street_1 = gets.chomp
        print "Address line 2: "
        address.street_2 = gets.chomp
        print "City: "
        address.city = gets.chomp
        print "State: "
        address.state = gets.chomp
        print "Postal Code: "
        address.postal_code = gets.chomp

        contact.addresses.push(address)
      else
        print "\n"
        break # take us back to main menu
      end
    end

    contacts.push(contact)
  end

  # Notice: We duplicate results printing in both find_by_name and find_by_phone_number
  # Thus we define a method called print_results to eliminate these duplicates
  # When we encounter an error, we only need to change code in one spot!
  def print_results(search, results)
    puts search

    results.each do |contact|
      puts contact.to_s("full_name")
      contact.print_phone_numbers
      contact.print_addresses
      puts "\n"
    end
  end

  def find_by_name(name)
    results = []
    search = name.downcase
    # Iterate through contacts, if it matches, append that contact to results array
    contacts.each do |contact|
      if contact.full_name.downcase.include?(search)
        results.push(contact)
      end
    end

    print_results("Name search results (#{search})", results)
  end

  def find_by_phone_number(number)
    results = []
    search = number.gsub("-", "") # replace dashes in number with nothing e.g. 11-111 -> 11111

    contacts.each do |contact|
      contact.phone_numbers.each do |phone_number|
        if phone_number.number.gsub("-", "").include?(search)
          # append contact to results, unless contact already included
          results.push(contact) unless results.include?(contact)
        end
      end
    end

    print_results("Phone search results (#{search})", results)
  end

  def find_by_address(query)
    results = []
    search = query.downcase

    contacts.each do |contact| # loop through contacts
      contact.addresses.each do |address| # for each contact, loop through address
        if address.to_s("long").downcase.include?(search)
          results.push(contact) unless results.include?(contact)
        end
      end
    end

    print_results("Address search results (#{search})", results)
  end

  def print_contact_list
    puts "Contact List"
    contacts.each do |contact|
      puts contact.to_s("last_first")
    end
  end
end

address_book = AddressBook.new
address_book.run # display menu
