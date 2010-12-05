/*
 *  ArchiveIndex.cpp
 *  RAA
 *
 *  Created by Rowan James on 5/12/10.
 *  Copyright 2010 Rowan James. All rights reserved.
 *
 */

#include "ArchiveIndex.h"

ArchiveIndex::ArchiveIndex()
{
}

size_t ArchiveIndex::Add(const string& strFile, const size_t& iOffset)
{
	size_t iThisFileSize(0);
	path oPath(strFile);
	if (is_regular_file(oPath)) {
		ArchiveIndexEntry oEntry(oPath, iOffset);
		iThisFileSize = oEntry.GetFileSize();
		m_aEntries.push_back(oEntry);
	}
	return iThisFileSize;
}

size_t ArchiveIndex::SizeInFile() const
{
	size_t iResult = 0;
	foreach (const ArchiveIndexEntry& oEntry, m_aEntries) {
		iResult += oEntry.SizeInFile();
	}
	return iResult;
}

size_t ArchiveIndex::NumberOfFiles() const
{
	return m_aEntries.size();
}

void ArchiveIndex::Write(ofstream& oFile) const
{
	foreach (const ArchiveIndexEntry& oEntry, m_aEntries) {
		oEntry.Write(oFile);
	}
}
