/*
 *  ArchiveIndex.h
 *  RAA
 *
 *  Created by Rowan James on 5/12/10.
 *  Copyright 2010 Rowan James. All rights reserved.
 *
 */

#import "ArchiveIndexEntry.h"

class ArchiveIndex
{
public:
	ArchiveIndex();
	
	size_t Add(const string& strFileName, const size_t& iOffset);
	
	void Write(ofstream& oFile) const;

	size_t SizeInFile() const;
	size_t NumberOfFiles() const;
	
protected:
	list<ArchiveIndexEntry> m_aEntries;
};
