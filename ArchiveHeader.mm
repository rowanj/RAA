/*
 *  ArchiveHeader.cpp
 *  RAA
 *
 *  Created by Rowan James on 5/12/10.
 *  Copyright 2010 Rowan James. All rights reserved.
 *
 */

#include "ArchiveHeader.h"

#import "Archive.h"
#import "ArchiveIndex.h"

ArchiveHeader::ArchiveHeader(const ArchiveIndex& oIndex)
{
	m_iVersion = 1;
	memset(m_pszMagic, 0, sizeof(m_pszMagic));
	strcpy(m_pszMagic, "Random Access Archive");
	m_iIndexOffset = sizeof(this);
	m_iDataOffset = RAA::AlignToPacking(sizeof(this) + oIndex.SizeInFile());
	m_iObjectAlignment = RAA::iARCHIVE_PACKING;
	m_iNumberOfFiles = oIndex.NumberOfFiles();
}

void ArchiveHeader::Write(ofstream& oFile) const
{
	ArchiveHeader oLEClone(*this);
	
	oLEClone.m_iVersion = CFSwapInt32HostToLittle(m_iVersion);
	oLEClone.m_iIndexOffset = CFSwapInt32HostToLittle(m_iVersion);
	oLEClone.m_iDataOffset = CFSwapInt32HostToLittle(m_iDataOffset);
	oLEClone.m_iObjectAlignment = CFSwapInt32HostToLittle(m_iObjectAlignment);
	oLEClone.m_iNumberOfFiles = CFSwapInt32HostToLittle(m_iNumberOfFiles);
	
	oFile.write(reinterpret_cast<const char*>(&oLEClone), sizeof(oLEClone));
}
