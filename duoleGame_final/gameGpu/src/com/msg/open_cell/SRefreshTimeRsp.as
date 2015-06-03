package com.msg.open_cell {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.enumdef.RspMsg;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SRefreshTimeRsp extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RSP:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.open_cell.SRefreshTimeRsp.rsp", "rsp", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.enumdef.RspMsg);

		public var rsp:int;

		/**
		 *  @private
		 */
		public static const OLTIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.open_cell.SRefreshTimeRsp.oltime", "oltime", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var oltime:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.rsp);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.oltime);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var rsp$count:uint = 0;
			var oltime$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (rsp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SRefreshTimeRsp.rsp cannot be set twice.');
					}
					++rsp$count;
					this.rsp = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (oltime$count != 0) {
						throw new flash.errors.IOError('Bad data format: SRefreshTimeRsp.oltime cannot be set twice.');
					}
					++oltime$count;
					this.oltime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
