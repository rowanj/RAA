/*
 *  ArchiveIndexEntry.h
 *  RAA
 *
 *  Created by Rowan James on 5/12/10.
 *  Copyright 2010 Rowan James. All rights reserved.
 *
 */

class ArchiveIndexEntry
{
public:
	ArchiveIndexEntry(const path& oPath, const size_t& iOffset);
	ArchiveIndexEntry(const ArchiveIndexEntry& other);
	
	void Write(ofstream& oFile) const;
	
	size_t GetFileSize() const;
	size_t SizeInFile() const;
	
public:
	uint32_t m_iFileOffset; // relative to data area
	uint32_t m_iFileSize;
	string m_strPath;
};
