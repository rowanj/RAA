#import "Archive.h"

bool bVerbose = false;

int main (int argc, char * argv[]) {
	options_description oOptionsDesc("Allowed options");
	
	oOptionsDesc.add_options()
	("output,o", value<string>(), "Output archive")
	("input,i", value< vector<string> >(), "Input file(s)")
	("verbose,v", "Verbose mode");
	
	positional_options_description oInputDesc;
	oInputDesc.add("input", -1);

	variables_map oCommandVars;
	try {
		store(command_line_parser(argc, argv).options(oOptionsDesc).positional(oInputDesc).run(), oCommandVars);
		notify(oCommandVars);
	} catch (unknown_option& oEx) {
		cerr << "Error: " << oEx.what() << endl;
		cerr << oOptionsDesc << endl;
	} catch (invalid_command_line_syntax& oEx) {
		cerr << "Error: " << oEx.what() << endl;
		cerr << oOptionsDesc << endl;
	}
	
	bVerbose = oCommandVars.count("verbose");
	
	if (oCommandVars.count("output") <= 0) {
		cerr << "Error: must specify output file" << endl;
		cerr << oOptionsDesc << endl;
		return 1;
	}
	string strOutFile(oCommandVars["output"].as<string>());
	if (strOutFile.empty()) {
		cerr << "Error: output file name cannot be empty" << endl;
		cerr << oOptionsDesc << endl;
		return 1;
	}
	
	size_t iInputFiles = oCommandVars.count("input");
	if (iInputFiles <= 0) {
		cerr << "Error: no input files specified" << endl;
		return 1;
	}
	
	vector<string> aInFiles(oCommandVars["input"].as< vector<string> >());
	Archive oArchive;
	
	foreach (string strFile, aInFiles) {
		if (strFile != strOutFile) {
			oArchive += strFile;
		}
	}
	
	if (oArchive.CountFiles() > 0) {
		if (bVerbose) {
			cout << "Writing to archive: " << strOutFile <<  endl;
		}
		try {
			oArchive.WriteTo(strOutFile);
			return 0;
		} catch (...) {
			cerr << "Unhandled exception while writing archive: " << strOutFile << endl;
			return 1;
		}
	} else {
		cerr << "Refusing to write empty archive: " << strOutFile << endl;
		return 1;
	}
	
    return 1;
}
