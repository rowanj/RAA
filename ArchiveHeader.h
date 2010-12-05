/*
 *  ArchiveHeader.h
 *  RAA
 *
 *  Created by Rowan James on 5/12/10.
 *  Copyright 2010 Rowan James. All rights reserved.
 *
 */

class ArchiveIndex;

class ArchiveHeader
{
public:
	ArchiveHeader(const ArchiveIndex& oIndex);
	
	void Write(ofstream& oFile) const;
	
private:
	uint32_t m_iVersion;
	char m_pszMagic[40];
	uint32_t m_iIndexOffset;
	uint32_t m_iDataOffset;
	uint32_t m_iObjectAlignment;
	uint32_t m_iNumberOfFiles;
};
