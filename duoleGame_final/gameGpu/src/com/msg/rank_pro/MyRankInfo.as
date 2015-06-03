package com.msg.rank_pro {
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
	public dynamic final class MyRankInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RANK_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.MyRankInfo.rank_type", "rankType", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var rankType:int;

		/**
		 *  @private
		 */
		public static const RANK_ORDER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.MyRankInfo.rank_order", "rankOrder", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var rankOrder:int;

		/**
		 *  @private
		 */
		public static const RANK_VALUE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.MyRankInfo.rank_value", "rankValue", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var rankValue:int;

		/**
		 *  @private
		 */
		public static const VIP_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.MyRankInfo.vip_level", "vipLevel", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var vip_level$field:int;

		private var hasField$0:uint = 0;

		public function clearVipLevel():void {
			hasField$0 &= 0xfffffffe;
			vip_level$field = new int();
		}

		public function get hasVipLevel():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set vipLevel(value:int):void {
			hasField$0 |= 0x1;
			vip_level$field = value;
		}

		public function get vipLevel():int {
			return vip_level$field;
		}

		/**
		 *  @private
		 */
		public static const VIP_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.MyRankInfo.vip_type", "vipType", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var vip_type$field:int;

		public function clearVipType():void {
			hasField$0 &= 0xfffffffd;
			vip_type$field = new int();
		}

		public function get hasVipType():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set vipType(value:int):void {
			hasField$0 |= 0x2;
			vip_type$field = value;
		}

		public function get vipType():int {
			return vip_type$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.rankType);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.rankOrder);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.rankValue);
			if (hasVipLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, vip_level$field);
			}
			if (hasVipType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, vip_type$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var rank_type$count:uint = 0;
			var rank_order$count:uint = 0;
			var rank_value$count:uint = 0;
			var vip_level$count:uint = 0;
			var vip_type$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (rank_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: MyRankInfo.rankType cannot be set twice.');
					}
					++rank_type$count;
					this.rankType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (rank_order$count != 0) {
						throw new flash.errors.IOError('Bad data format: MyRankInfo.rankOrder cannot be set twice.');
					}
					++rank_order$count;
					this.rankOrder = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (rank_value$count != 0) {
						throw new flash.errors.IOError('Bad data format: MyRankInfo.rankValue cannot be set twice.');
					}
					++rank_value$count;
					this.rankValue = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (vip_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: MyRankInfo.vipLevel cannot be set twice.');
					}
					++vip_level$count;
					this.vipLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (vip_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: MyRankInfo.vipType cannot be set twice.');
					}
					++vip_type$count;
					this.vipType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
