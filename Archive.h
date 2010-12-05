/*
 *  Archive.h
 *  RAA
 *
 *  Created by Rowan James on 5/12/10.
 *  Copyright 2010 Rowan James. All rights reserved.
 *
 */

#import <list>
#import <string>

class Archive
{
public:
	Archive();
	
	Archive& operator+=(const string& strFile);

	void WriteTo(const string& strArchive);
	
	size_t CountFiles() const;

private:
	void AddPath(const path& oPath);

	vector<string> m_aFiles;
	size_t m_iRecursionLevel;
};

namespace RAA
{
	const size_t iARCHIVE_PACKING = 4096;
	size_t AlignTo(size_t iAlignment, size_t iValue);
	size_t AlignToPacking(size_t iValue);
}
