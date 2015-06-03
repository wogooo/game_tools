package com.msg.vip_gift_pack {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SVipGiftPackRsp extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const VIP_NOVICE_PACK:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.vip_gift_pack.SVipGiftPackRsp.vip_novice_pack", "vipNovicePack", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var vip_novice_pack$field:int;

		private var hasField$0:uint = 0;

		public function clearVipNovicePack():void {
			hasField$0 &= 0xfffffffe;
			vip_novice_pack$field = new int();
		}

		public function get hasVipNovicePack():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set vipNovicePack(value:int):void {
			hasField$0 |= 0x1;
			vip_novice_pack$field = value;
		}

		public function get vipNovicePack():int {
			return vip_novice_pack$field;
		}

		/**
		 *  @private
		 */
		public static const VIP_EVERYDAY_PACK:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.vip_gift_pack.SVipGiftPackRsp.vip_everyday_pack", "vipEverydayPack", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var vip_everyday_pack$field:int;

		public function clearVipEverydayPack():void {
			hasField$0 &= 0xfffffffd;
			vip_everyday_pack$field = new int();
		}

		public function get hasVipEverydayPack():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set vipEverydayPack(value:int):void {
			hasField$0 |= 0x2;
			vip_everyday_pack$field = value;
		}

		public function get vipEverydayPack():int {
			return vip_everyday_pack$field;
		}

		/**
		 *  @private
		 */
		public static const VIP_NOBLE_PACK:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.vip_gift_pack.SVipGiftPackRsp.vip_noble_pack", "vipNoblePack", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var vip_noble_pack$field:int;

		public function clearVipNoblePack():void {
			hasField$0 &= 0xfffffffb;
			vip_noble_pack$field = new int();
		}

		public function get hasVipNoblePack():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set vipNoblePack(value:int):void {
			hasField$0 |= 0x4;
			vip_noble_pack$field = value;
		}

		public function get vipNoblePack():int {
			return vip_noble_pack$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasVipNovicePack) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, vip_novice_pack$field);
			}
			if (hasVipEverydayPack) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, vip_everyday_pack$field);
			}
			if (hasVipNoblePack) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, vip_noble_pack$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var vip_novice_pack$count:uint = 0;
			var vip_everyday_pack$count:uint = 0;
			var vip_noble_pack$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (vip_novice_pack$count != 0) {
						throw new flash.errors.IOError('Bad data format: SVipGiftPackRsp.vipNovicePack cannot be set twice.');
					}
					++vip_novice_pack$count;
					this.vipNovicePack = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (vip_everyday_pack$count != 0) {
						throw new flash.errors.IOError('Bad data format: SVipGiftPackRsp.vipEverydayPack cannot be set twice.');
					}
					++vip_everyday_pack$count;
					this.vipEverydayPack = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (vip_noble_pack$count != 0) {
						throw new flash.errors.IOError('Bad data format: SVipGiftPackRsp.vipNoblePack cannot be set twice.');
					}
					++vip_noble_pack$count;
					this.vipNoblePack = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
