package com.msg.item {
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
	public dynamic final class CInlayGemReq extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const EQUIP_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CInlayGemReq.equip_pos", "equipPos", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var equipPos:int;

		/**
		 *  @private
		 */
		public static const INLAY_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CInlayGemReq.inlay_pos", "inlayPos", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var inlayPos:int;

		/**
		 *  @private
		 */
		public static const GEM_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CInlayGemReq.gem_pos", "gemPos", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var gemPos:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.equipPos);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.inlayPos);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.gemPos);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var equip_pos$count:uint = 0;
			var inlay_pos$count:uint = 0;
			var gem_pos$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (equip_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: CInlayGemReq.equipPos cannot be set twice.');
					}
					++equip_pos$count;
					this.equipPos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (inlay_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: CInlayGemReq.inlayPos cannot be set twice.');
					}
					++inlay_pos$count;
					this.inlayPos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (gem_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: CInlayGemReq.gemPos cannot be set twice.');
					}
					++gem_pos$count;
					this.gemPos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
