#!/usr/local/bin/perl -w

# Name: John Ryles
# Date: October 1st, 2012
# Program Purpose: This is an implementation of Flitter, a CS405 assignment that 
# mimics the user interactions of current day Twitter. The user will have a login
# username and password and be able to post "Fleets" about what they are doing
# and be able to follow their friends and read what they are doing as well.

# For connecting to MySQL through Program
use DBI;

# Information variables to connect to MySQL
$Cdriver = "*****";
$Cdbase = "*****";
$Chost = "*****";
$Cuser = "*****";
$Cpass = "*****";

# Connect to MySQL through DBI
$dbh = DBI->connect("DBI:$Cdriver:database=$Cdbase;host=$Chost",$Cuser,$Cpass);

# If didn't connect -> Terminate program
die "Cannot connect: $DBI::errstr" unless $dbh;

# MySQL create table statement
$createFlitters = 
"
CREATE TABLE flitters 
(
	handle VARCHAR(25),
	password VARCHAR(25),
	first_name VARCHAR(15),
	last_name VARCHAR(20),
	location VARCHAR(30),
	PRIMARY KEY(handle)
)";

# Create table "flitters"
$sth = $dbh->prepare($createFlitters);
$sth->execute();

# MySQL create table statement
$createFleets = 
"
CREATE TABLE fleets
(
	handle VARCHAR(25),
	password VARCHAR(25),
	fleet VARCHAR(155)
)";

# MySQL create table statement
$createFollows = 
"
CREATE TABLE follows
(
	handle VARCHAR(25)
)";

# Random users to add into flitter program to simulate environment
$randomUser1 = "INSERT INTO flitters VALUES('\@paul','paul','Paul','Linton','Lexington, KY')";
$randomUser2 = "INSERT INTO flitters VALUES('\@nikki','nikki','Nikki','Ryles','Lexington, KY')";
$randomUser3 = "INSERT INTO flitters VALUES('\@bill','bill','Bill','Gates','Seattle, WA')";
$randomUser4 = "INSERT INTO flitters VALUES('\@dana','dana','Dana','White','Las Vegas, NV')";
$randomUser5 = "INSERT INTO flitters VALUES('\@ben','ben','Ben','Stiller','New York City, NY')";
$randomUser6 = "INSERT INTO flitters VALUES('\@john','john','John','Smith','Kansas City, KS')";

# Add random users into "flitters" table
$sth = $dbh->prepare($randomUser1);
$sth->execute();
$sth = $dbh->prepare($randomUser2);
$sth->execute();
$sth = $dbh->prepare($randomUser3);
$sth->execute();
$sth = $dbh->prepare($randomUser4);
$sth->execute();
$sth = $dbh->prepare($randomUser5);
$sth->execute();
$sth = $dbh->prepare($randomUser6);
$sth->execute();

# Create table fleets
$sth = $dbh->prepare($createFleets);
$sth->execute();

# Random fleets
$randomFleet1 = "INSERT INTO fleets VALUES('\@paul','paul','Heading to work this morning.')";
$randomFleet2 = "INSERT INTO fleets VALUES('\@nikki','nikki','On my way home from the grocery.')";
$randomFleet3 = "INSERT INTO fleets VALUES('\@nikki','nikki','Cannot wait to get off work today!')";
$randomFleet4 = "INSERT INTO fleets VALUES('\@bill','bill','I am so rich it is scary!')";
$randomFleet5 = "INSERT INTO fleets VALUES('\@john','john','Where am I?')";
$randomFleet6 = "INSERT INTO fleets VALUES('\@dana','dana','Fight week!')";
$randomFleet7 = "INSERT INTO fleets VALUES('\@paul','paul','Finished grading homework for the night.')";
$randomFleet8 = "INSERT INTO fleets VALUES('\@ben','ben','Just finished a new movie shoot!')";
$randomFleet9 = "INSERT INTO fleets VALUES('\@john','john','What year is it?')";
$randomFleet10 = "INSERT INTO fleets VALUES('\@dana','dana','What did you think about the fight?')";

# Add random fleets into "fleets" table
$sth = $dbh->prepare($randomFleet1);
$sth->execute();
$sth = $dbh->prepare($randomFleet2);
$sth->execute();
$sth = $dbh->prepare($randomFleet3);
$sth->execute();
$sth = $dbh->prepare($randomFleet4);
$sth->execute();
$sth = $dbh->prepare($randomFleet5);
$sth->execute();
$sth = $dbh->prepare($randomFleet6);
$sth->execute();
$sth = $dbh->prepare($randomFleet7);
$sth->execute();
$sth = $dbh->prepare($randomFleet8);
$sth->execute();
$sth = $dbh->prepare($randomFleet9);
$sth->execute();
$sth = $dbh->prepare($randomFleet10);
$sth->execute();

# Create table follows
$sth = $dbh->prepare($createFollows);
$sth->execute();

# Boolean used to check if user entered valid username
$validUserName = FALSE;

# Welcome message from Flitter
print "\n\nWelcome to Flitter! To get started, please Login:\n\n";

# Test to see if User name is valid (@ is required at beginning of username)
while ($validUserName eq FALSE)
{
	# Prompt user to enter username
	print "Username: ";
	$userID = <STDIN>;

	# Remove carriage return
	chomp($userID);

	# Check if valid username entered
	if (checkValidUser($userID) eq TRUE)
	{
		$validUserName = TRUE;
	}
}

# Test variable to see if password entered is valid
$validPassword = FALSE;

# Test to see if user entered correct password
while ($validPassword eq FALSE)
{
	print "Password: ";
	$userPassword = <STDIN>;
	
	# Remove carriage return
	chomp($userPassword);
	
	# Test to see if password is greater than 0 in length and less than/equal to 25
	if (checkValidPassword($userPassword) eq TRUE)
	{
		# Now check if username and password are in database
		$checkUser = "SELECT handle FROM flitters WHERE handle='$userID'";
		$sth = $dbh->prepare($checkUser);
		$sth->execute();
	
		# Test variable
		$usersInDatabase = TRUE;
		
		# Check if in database or not
		unless($sth->fetch())
		{
			# Test variable to see if user is in database
			$usersInDatabase = FALSE;
	
			# If not in table -> Ask for more details
			print "You are not in the database, To Login to Flitter, Please answer following questions:\n";
	
			# Check for Valid First Name entry
			$validEntry = FALSE;
			while ($validEntry eq FALSE)
			{
				print "What is your First name? ";
				$firstName = <STDIN>;
				chomp($firstName);
	
				# Check if in range of length [1,15]
				if (checkValidFirstName($firstName) eq TRUE)
				{
					$validEntry = TRUE;
				}
			}

			# Check for Valid Last Name entry
			$validEntry = FALSE;
			while ($validEntry eq FALSE)
			{
				print "What is your Last name? ";
				$lastName = <STDIN>;
				chomp($lastName);
	
				# Check if in range of [1,20]
				if (checkValidLastName($lastName) eq TRUE)
				{
					$validEntry = TRUE;
				}
			}

			# Check for valid Location
			$validEntry = FALSE;
			while ($validEntry eq FALSE)
			{
				print "What location are you at? (ex. Lexington, KY) ";
				$location = <STDIN>;
				chomp($location);
	
				# Check range of Location [1,30]
				if (checkValidLocation($location) eq TRUE)
				{
					$validEntry = TRUE;
				}
			}

			#-> Add handle & password
			print "Entering user into database...\n";
			$addUser = "INSERT INTO flitters VALUES('$userID','$userPassword','$firstName','$lastName','$location')";
			$sth = $dbh->prepare($addUser);
			$sth->execute();
			$validPassword = TRUE;
		}

		# Check if user is in database -> check password if it matches
		if ($usersInDatabase eq TRUE)
		{
			$passCheck = "SELECT $userID FROM flitters WHERE handle='$userID' and password='$userPassword'";
			$sth = $dbh->prepare($passCheck);
			$sth->execute();
			
			# Occurs only when password doesn't match with the 'handle'
			unless ($sth->fetch())
			{
				print "Password Entered was invalid for $userID\n";
				next;
			}
			$validPassword = TRUE;
		}
	}
	# Else test failed and need to re-enter	
	else
	{
		print "Invalid password entered.\n";
	}
}

# Add yourself to follows table to see your own fleets!
$sth = $dbh->prepare("INSERT INTO follows VALUES('$userID')");
$sth->execute();

# Start Menu Display
print "\nWelcome to Flitter! Flitter is an interactive application that is designed to keep you and your followers connected to one another. ";
print "To use Flitter just simply follow the instruction menu below: \n";

# Clear user input
$userInput = "";

# Print main menu
while ($userInput ne "exit")
{
	print "\nMenu:\n";
	print "ADD NEW USER: Type-> 'adduser'\n"; 
	print "VIEW ALL MEMBERS: Type-> 'searchuser all'\n";
	print "SEARCH FOR USER: Type-> 'searchuser username'\n"; 
	print "FOLLOW USER: Type-> 'follow username'\n";
	print "UNFOLLOW USER: Type-> 'unfollow username'\n"; 
	print "POST FLEET: Type-> 'post fleet'\n"; 
	print "VIEW FLEETS FROM FOLLOWED: Type-> 'showfleets'\n"; 
	print "VIEW FLEETS FROM SPECIFIC USER: Type-> 'showfleets username'\n";
	print "VIEW USERS YOU FOLLOW: Type-> 'view follows'\n"; 
	print "EXIT FLITTER: Type-> 'exit'\n\n"; 
	$userInput = <STDIN>;
	chomp($userInput);

	# If user enters "exit"
	if ($userInput eq "exit")
	{
		print "\nGoodbye $userID!\n\n";
	}

	# If user enters "post fleet"
	elsif ($userInput eq "post fleet")
	{
		print "\nEnter fleet here: ";
		$fleetPost = <STDIN>;
		chomp($fleetPost);
		
		# Check if valid fleet post
		if (checkValidFleetPost($fleetPost) eq FALSE)
		{
			print "Invalid fleet post... Returning to Main Menu\n";
			next;
		}
		else # Post it
		{
			$sth = $dbh->prepare("INSERT INTO fleets VALUES(?,?,?)");
			$sth->execute($userID,$userPassword,$fleetPost);
			print "Fleet post added!\n";
		}
	}

	# If user enteres "adduser"
	elsif ($userInput eq "adduser")
	{
		print "\nPlease provide your username: ";
		$checkUserID = <STDIN>;
		chomp($checkUserID);
		
		# If username wasn't verified
		if ($checkUserID ne $userID)
		{
			print "Your username didn't match username that was logged in: $userID... Returning to Main Menu\n";
			next;
		}
		print "\nPlease provide your password: ";
		$checkUserPassword = <STDIN>;
		chomp($checkUserPassword);

		# If password wasn't verified
		if ($checkUserPassword ne $userPassword)
		{
			print "Your password didn't match password for username: $userID... Returning to Main Menu\n";
			next;
		}
		print "\nTo add new user, please answer the following questions:\n\n";
		print "What is the username going to be? (Begins with '\@'): ";
		$h = <STDIN>;
		chomp($h);
	
		# If valid username wasn't entered
		if (checkValidUser($h) eq FALSE)
		{
			print "Invalid username entered... Returning to Main Menu\n";
			next;
		}
		print "What is the password going to be for $h? ";
		$p = <STDIN>;
		chomp($p);
	
		# If valid password wasn't entered
		if (checkValidPassword($p) eq FALSE)
		{
			print "Invalid password entered... Returning to Main Menu\n";
			next;
		}
		print "What is the users first name? ";
		$fn = <STDIN>;
		chomp($fn);

		# If valid first name wasn't entered
		if (checkValidFirstName($fn) eq FALSE)
		{
			print "Invalid first name entered... Returning to Main Menu\n";
			next;
		}
		print "What is the users last name? ";
		$ln = <STDIN>;
		chomp($ln);

		# If valid last name wasn't entered
		if (checkValidLastName($ln) eq FALSE)
		{
			print "Invalid last name entered... Returning to Main Menu\n";
			next;
		}
		print "What is the users location? (ex. Lexington, KY): ";
		$loc = <STDIN>;
		chomp($loc);

		# If valid location wasn't entered
		if (checkValidLocation($loc) eq FALSE)
		{
			print "Invalid location entered... Returning to Main Menu\n";
			next;
		}
		print "Adding user to database...\n";
		
		# Add new user
		$userInformation = "INSERT INTO flitters VALUES('$h','$p','$fn','$ln','$loc')";
		$sth = $dbh->prepare($userInformation);
		$sth->execute();
	}
	
	# If user enters "searchuser all"
	elsif ($userInput eq "searchuser all")
	{
		print "\nPlease provide your username: ";
		$checkUserID = <STDIN>;
		chomp($checkUserID);
	
		# If username wasn't verified
		if ($checkUserID ne $userID)
		{
			print "Your username didn't match username that was logged in: $userID... Returning to Main Menu\n";
			next;
		}
		print "\nPlease provide your password: ";
		$checkUserPassword = <STDIN>;
		chomp($checkUserPassword);

		# If password wasn't verified for user that was logged in
		if ($checkUserPassword ne $userPassword)
		{
			print "Your password didn't match password for username: $userID... Returning to Main Menu\n";
			next;
		}

		# Display all flitter members handle (usernames)
		$sth = $dbh->prepare("SELECT handle FROM flitters");
		$sth->execute();
		$sth->bind_columns(\$col1);
		print "Here are all the flitter member account usernames:\n";
		while ($sth->fetch())
		{
			print "$col1 \n";
		}
	}

	# If user enteres "searchuser @username"
	elsif ($userInput =~ /searchuser /)
	{
		print "\nPlease provide your username: ";
		$test1 = <STDIN>;
		chomp($test1);

		# If username wasn't verified
		if ($test1 ne $userID)
		{
			print "Your username didn't match username that was logged in: $userID... Returning to Main Menu\n";
			next;
		}
		print "\nPlease provide your password: ";
		$test2 = <STDIN>;
		chomp($test2);

		# If password wasn't verified for logged in user
		if ($test2 ne $userPassword)
		{
			print "Your password didn't match password for username: $userID... Returning to Main Menu\n";
			next;
		}

		# Search for user here
		($first,$second) = split(/\s/,$userInput,2);
		$first = 0; # to avoid warning
		$sth = $dbh->prepare("SELECT handle FROM flitters WHERE handle='$second'\n");
		$sth->execute();
		$sth->bind_columns(\$col1);
		$findUser = FALSE;
		while ($sth->fetch())
		{
			print "\nFound: $col1\n";
			$findUser = TRUE;
		}

		# User wasn't found
		if ($findUser eq FALSE)
		{		
			print "\n$second was not found\n";
		}
	}

	# If user enteres "unfollow @username"
	elsif ($userInput =~ /unfollow\s{1}\@[a-zA-Z]+/)
	{
		print "\nPlease provide your username: ";
		$test1 = <STDIN>;
		chomp($test1);

		# If username wasn't verified
		if ($test1 ne $userID)
		{
			print "Your username didn't match username that was logged in: $userID... Returning to Main Menu\n";
			next;
		}
		print "\nPlease provide your password: ";
		$test2 = <STDIN>;
		chomp($test2);

		# If password wasn't verified
		if ($test2 ne $userPassword)
		{
			print "Your password didn't match password for username: $userID... Returning to Main Menu\n";
			next;
		}

		# Unfollow user here
		($first,$second) = split(/\s/,$userInput,2);
		$first = 0; # to avoid warning
		# Check if user is being followed by user
		$sth = $dbh->prepare("SELECT handle FROM follows WHERE handle='$second'");
		$sth->execute();
		$unFollowUser = TRUE;

		# Occurs when you aren't following that user to begin with
		unless ($sth->fetch())
		{
			print "You cannot unfollow user: $second because you are not following them!\n";
			$unFollowUser = FALSE;
		}

		# Remove annoying friend's post here
		if ($unFollowUser eq TRUE)
		{
			$sth = $dbh->prepare("DELETE FROM follows WHERE handle='$second'");
			$sth->execute();
			print "You have unfollowed $second\n";
		}
	}

	# If user enters "follow @username"
	elsif ($userInput =~ /follow\s{1}\@[a-zA-Z]+/)
	{
		print "\nPlease provide your username: ";
		$test1 = <STDIN>;
		chomp($test1);

		# If username wasn't verified
		if ($test1 ne $userID)
		{
			print "Your username didn't match username that was logged in: $userID... Returning to Main Menu\n";
			next;
		}
		print "\nPlease provide your password: ";
		$test2 = <STDIN>;
		chomp($test2);
		
		# If password wasn't verified
		if ($test2 ne $userPassword)
		{
			print "Your password didn't match password for username: $userID... Returning to Main Menu\n";
			next;
		}

		# Follow user here
		($first,$second) = split(/\s/,$userInput,2);
		$first = 0; # to avoid warning
		# Check if user is in database first
		$sth = $dbh->prepare("SELECT handle FROM flitters WHERE handle='$second'");
		$sth->execute();
		$followUser = TRUE;

		# Occurs when user doesn't exist
		unless ($sth->fetch())
		{
			print "You cannot follow user: $second because they do not have a flitter account!\n";
			$followUser = FALSE;
		}

		# Follow user
		if ($followUser eq TRUE)
		{
			$sth = $dbh->prepare("INSERT INTO follows VALUES('$second')");
			$sth->execute();
			print "You are now following $second\n";
		}
	}

	# If user enters "showfleets"
	elsif ($userInput eq "showfleets")
	{
		print "\nPlease provide your username: ";
		$test1 = <STDIN>;
		chomp($test1);

		# If username wasn't verified
		if ($test1 ne $userID)
		{
			print "Your username didn't match username that was logged in: $userID... Returning to Main Menu\n";
			next;
		}
		print "\nPlease provide your password: ";
		$test2 = <STDIN>;
		chomp($test2);

		# If password wasn't verified
		if ($test2 ne $userPassword)
		{
			print "Your password didn't match password for username: $userID... Returning to Main Menu\n";
			next;
		}

		# Show fleets here
		print "\n";
		$sth = $dbh->prepare("SELECT follows.handle,fleets.fleet FROM fleets NATURAL JOIN follows WHERE follows.handle=fleets.handle");
		$sth->execute();
		$sth->bind_columns(\$col1,\$col2);
		$fleetsToPost = FALSE;
		while ($sth->fetch())
		{
			print "$col1 -> $col2\n";
			$fleetsToPost = TRUE;
		}
		if ($fleetsToPost eq FALSE)
		{
			print "You have no fleets from users that you follow!\n";
		}
	}

	# If user enters "showfleets @username"
	elsif ($userInput =~ /showfleets\s{1}\@[a-zA-Z]+/)
	{
		print "\nPlease provide your username: ";
		$test1 = <STDIN>;
		chomp($test1);

		# If username wasn't verified
		if ($test1 ne $userID)
		{
			print "Your username didn't match username that was logged in: $userID... Returning to Main Menu\n";
			next;
		}
		print "\nPlease provide your password: ";
		$test2 = <STDIN>;
		chomp($test2);

		# If password wasn't verified
		if ($test2 ne $userPassword)
		{
			print "Your password didn't match password for username: $userID... Returning to Main Menu\n";
			next;
		}

		# Show fleets for specific user here
		print "\n";
		($first,$second) = split(/\s/,$userInput,2);
		$first = 0; # to avoid warning
		$sth = $dbh->prepare("SELECT handle,fleet FROM fleets WHERE handle='$second'");
		$sth->execute();
		$sth->bind_columns(\$col1, \$col2);
		$userHasFleets = FALSE;
		while ($sth->fetch())
		{
			print "$col1 -> $col2\n";
			$userHasFleets = TRUE;
		}

		# User hasn't posted any fleets yet
		if ($userHasFleets eq FALSE)
		{
			print "User: $second does not have any posted fleets!\n";
		}
	}

	# If user enters "view follows"
	elsif ($userInput eq "view follows")
	{
		print "\nPlease provide your username: ";
		$test1 = <STDIN>;
		chomp($test1);

		# If username wasn't verified
		if ($test1 ne $userID)
		{
			print "Your username didn't match username that was logged in: $userID... Returning to Main Menu\n";
			next;
		}
		print "\nPlease provide your password: ";
		$test2 = <STDIN>;
		chomp($test2);

		# If password wasn't verified
		if ($test2 ne $userPassword)
		{
			print "Your password didn't match password for username: $userID... Returning to Main Menu\n";
			next;
		}

		# View all the users you follow here
		print "\n";
		$sth = $dbh->prepare("SELECT handle FROM follows");
		$sth->execute();
		$sth->bind_columns(\$col1);
		$followAnyone = FALSE;
		while ($sth->fetch())
		{
			print "$col1\n";
			$followAnyone = TRUE;
		}

		# You aren't following anyone
		if ($followAnyone eq FALSE)
		{
			print "You are not following anyone!\n";
		}
	}

	# If user enters non-menu item
	else
	{
		print "Invalid menu selection!\n";
	}
}

# Drop table follows
$dropTable = "DROP TABLE follows";
$sth = $dbh->prepare($dropTable);
$sth->execute();

# Drop table fleets
$dropTable = "DROP TABLE fleets";
$sth = $dbh->prepare($dropTable);
$sth->execute();

# Drop table flitters
$dropTable = "DROP TABLE flitters";
$sth = $dbh->prepare($dropTable);
$sth->execute();

# Check Valid Username
sub checkValidUser
{
	# First character must be the '@' symbol
	my $test = substr($_[0],0,1);
	if ($test eq "@")
	{
		# Length must not be 0 or bigger than 21
		if (length $_[0] > 0 && length $_[0] < 21)
		{
			return TRUE;
		}
		else
		{
			print "Username entered was invalid (must be less than 21 characters and larger than 0)! Please re-enter.\n";
			return FALSE;
		}
	}
	
	# Username was invalid
	else
	{
		print "Username must begin with an '\@'! Please re-enter.\n";
		return FALSE;
	}
}

# Check Valid Password
sub checkValidPassword
{
	# Length must be not 0 and less than 21
	if (length $_[0] > 0 && length $_[0] < 21)
	{
		return TRUE;
	}
	# Password was invalid
	else
	{
		print "Password entered was invalid (must be less than 21 characters and larger than 0)! Please re-enter.\n";
		return FALSE;
	}
}

# Check Valid First Name
sub checkValidFirstName
{
	# Length must be not 0 and less than 16
	if (length $_[0] > 0 && length $_[0] < 16)
	{
		# If only alpha characters
		if ($_[0] =~ /[a-zA-Z]+/)
		{
			# If any digits occur
			if ($_[0] =~ /\d+/)
			{
				print "First name cannont contain digits! Please re-enter.\n";
				return FALSE;
			}
			# Valid name
			else
			{
				return TRUE;
			}
		}
		# Invalid first name
		else
		{
			print "First name cannot contain digits! Please re-enter.\n";
			return FALSE;
		}
	}
	# Invalid first name
	else
	{
		print "First name was invalid! (Must be less than 16 characters and larger than 0)! Please re-enter.\n";
		return FALSE;
	}
}

# Check Valid Last Name
sub checkValidLastName
{
	# Length must not be 0 and less than 21
	if (length $_[0] > 0 && length $_[0] < 21)
	{
		# If only alpha characters
		if ($_[0] =~ /[a-zA-Z]+/)
		{
			# If any digits occur
			if ($_[0] =~ /\d+/)
			{
				print "Last name cannot contain digits! Please re-enter.\n";
				return FALSE;
			}
			# Valid last name
			else
			{
				return TRUE;
			}
		}
		# Invalid last name
		else
		{
			print "Last name connot contain digits! Please re-enter.\n";
			return FALSE;
		}
	}
	# Invalid last name
	else
	{
		print "Last name was invalid! (Must be less than 21 characters and larger than 0)! Please re-enter.\n";
		return FALSE;
	}
}

# Check Valid Location
sub checkValidLocation
{
	# Length must not be 0 and less than 30
	if (length $_[0] > 0 && length $_[0] < 31)
	{
		# Alpha characters only
		if ($_[0] =~ /[a-zA-Z]+/)
		{
			# If any digits occur
			if ($_[0] =~ /\d+/)
			{
				print "Location cannot contain digits! Please re-enter.\n";
				return FALSE;
			}
			# Valid location
			else
			{
				return TRUE;
			}
		}
		# Invalid location
		else
		{
			print "Location cannot contain digits! Please re-enter.\n";
		}
	}
	# Invalid location
	else
	{
		print "Location was invalid! (Must be less than 31 characters and larger than 0)! Please re-enter.\n";
		return FALSE;
	}
}

# Check valid fleet post
sub checkValidFleetPost
{
	# Length must not be 0 and less than 156
	if (length $_[0] > 0 && length $_[0] < 156)
	{
		return TRUE;
	}
	# Invalid post
	else
	{
		print "Fleet entered was invalid! (Must be less than 156 characters and larger than 0)! Please re-enter.\n";
		return FALSE;
	}
}
