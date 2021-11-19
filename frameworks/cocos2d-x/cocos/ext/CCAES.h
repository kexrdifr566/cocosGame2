﻿#ifndef __CCAES_H__
#define __CCAES_H__

#include <array>
#include <cstdint>

#define AES_BLOCK_SIZE 16

namespace ext
{
	typedef std::array<unsigned char, 32> aes_key;

	struct AES
	{
		static const uint32_t AESBlockSize = 16;

		static void EncryptData(uint8_t *contents, uint32_t num_bytes, const aes_key &key);

		static void DecryptData(uint8_t *contents, uint32_t num_bytes, const aes_key &key);
	};
}

#endif