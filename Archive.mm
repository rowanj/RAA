/*
 *  Archive.cpp
 *  RAA
 *
 *  Created by Rowan James on 5/12/10.
 *  Copyright 2010 Rowan James. All rights reserved.
 *
 */

#include "Archive.h"

#import "ArchiveHeader.h"
#import "ArchiveIndex.h"

namespace RAA
{
	size_t AlignToPacking(size_t iValue)
	{
		return AlignTo(iARCHIVE_PACKING, iValue);
	}
	
	size_t AlignTo(size_t iAlignment, size_t iValue)
	{
		if (iValue % iAlignment) {
			iValue /= iAlignment; // how many segments? (rounds down)
			iValue++; // add one for the remainder
			return iValue * iAlignment;
		} else {
			return iValue;
		}
	}
}


Archive::Archive() :
	m_iRecursionLevel(0)
{}

Archive& Archive::operator+=(const string& strFile)
{
	AddPath(strFile);
	return *this;
}

void Archive::AddPath(const path& oPath)
{
	const string strIndent(m_iRecursionLevel, '\t');
	if (!oPath.is_relative()) {
		cerr << strIndent << "Warning: " << oPath.string() << " ignored - only relative paths are supported." << endl;
		return;
	}
	
	if (is_directory(oPath)) {
		directory_iterator oDir(oPath);
		if (bVerbose) {
			cout << strIndent << "Descending into directory: " << oPath.string() << endl;
		}
		m_iRecursionLevel++;
		for (; oDir != directory_iterator(); ++oDir) {
			AddPath(*oDir);
		}
		m_iRecursionLevel--;
		if (bVerbose) {
			cout << strIndent << "Leaving directory: " << oPath.string() << endl;
		}
	} else if (is_regular_file(oPath)) {
		if (bVerbose) {
			cout << strIndent << "Adding: " << oPath.string() << endl;
		}
		m_aFiles.push_back(oPath.string());
	} else {
		cerr << strIndent << "Warning: " << oPath << " exists but is neither a regular file or a directory, skipped." << endl;
	}
}

void Archive::WriteTo(const string& strArchive)
{
	// Sort the paths that we're about to archive, to aid in lookup
	sort(m_aFiles.begin(), m_aFiles.end());
	// Remove any duplicate paths
	m_aFiles.erase(std::unique(m_aFiles.begin(), m_aFiles.end()), m_aFiles.end());
	
	ArchiveIndex oIndex;
	size_t iNextFileStart = 0;
	foreach (const string& strFile, m_aFiles) {
		// Inform the index structure of each of our files
		iNextFileStart += oIndex.Add(strFile, iNextFileStart); // returns size of the file added
		iNextFileStart = RAA::AlignToPacking(iNextFileStart);
	}

	// Create a suitable header
	ArchiveHeader oHeader(oIndex);

	
	ofstream oFile(strArchive.c_str());
	
	// Write the header
	oHeader.Write(oFile);
	
	// Write the index
	oIndex.Write(oFile);
	
	// Write the data
	char oBuffer[4096];
	foreach (const string& strFile, m_aFiles) {
		oFile.seekp(RAA::AlignToPacking(oFile.tellp()));
		
		std::ifstream oInputFile(strFile.c_str());
		while (oInputFile.good()) {
			oInputFile.read(oBuffer, 4096);
			oFile.write(oBuffer, oInputFile.gcount());
		}
	}
}

size_t Archive::CountFiles() const
{
	return m_aFiles.size();
}
