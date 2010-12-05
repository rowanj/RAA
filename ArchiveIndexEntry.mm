/*
 *  ArchiveIndexEntry.cpp
 *  RAA
 *
 *  Created by Rowan James on 5/12/10.
 *  Copyright 2010 Rowan James. All rights reserved.
 *
 */

#include "ArchiveIndexEntry.h"

#import "Archive.h"

ArchiveIndexEntry::ArchiveIndexEntry(const path& oPath, const size_t& iOffset)
{
	m_iFileOffset = iOffset;
	m_iFileSize = file_size(oPath);
	m_strPath = oPath.string();
}

ArchiveIndexEntry::ArchiveIndexEntry(const ArchiveIndexEntry& other) :
	m_iFileOffset(other.m_iFileOffset),
	m_iFileSize(other.m_iFileSize),
	m_strPath(other.m_strPath)
{
}

void ArchiveIndexEntry::Write(ofstream& oFile) const
{
	uint32_t iTmp;
	
	iTmp = CFSwapInt32HostToLittle(m_iFileOffset);
	oFile.write(reinterpret_cast<const char*>(&iTmp), sizeof(iTmp));
	iTmp = CFSwapInt32HostToLittle(m_iFileSize);
	oFile.write(reinterpret_cast<const char*>(&iTmp), sizeof(iTmp));
	iTmp = CFSwapInt32HostToLittle(m_strPath.length());
	oFile.write(reinterpret_cast<const char*>(&iTmp), sizeof(iTmp));
	
	iTmp = RAA::AlignTo(4, m_strPath.length() + 1);
	char* pszPath = new char[iTmp];
	memset(pszPath, 0, iTmp);
	memcpy(pszPath, m_strPath.c_str(), m_strPath.length());
	
	oFile.write(pszPath, iTmp);
	delete[] pszPath;
}

size_t ArchiveIndexEntry::GetFileSize() const
{
	return m_iFileSize;
}

size_t ArchiveIndexEntry::SizeInFile() const
{
	// the index entry is:
	// file_offset (4 bytes, from start of data area)
	// file_size (4 bytes)
	// path_length (4 bytes)
	// path (path_length + 1 ('\0' terminated), rounded up to 4 bytes)
	size_t iSize = 4 + 4 + 4;
	iSize += RAA::AlignTo(4, m_strPath.length() + 1);
	return iSize;
}
