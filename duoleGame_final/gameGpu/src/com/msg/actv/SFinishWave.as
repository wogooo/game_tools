package com.msg.actv {
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
	public dynamic final class SFinishWave extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const NEXT_WAVE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.actv.SFinishWave.next_wave", "nextWave", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var nextWave:int;

		/**
		 *  @private
		 */
		public static const NEXT_WAVE_SECONDS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.actv.SFinishWave.next_wave_seconds", "nextWaveSeconds", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var nextWaveSeconds:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.nextWave);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.nextWaveSeconds);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var next_wave$count:uint = 0;
			var next_wave_seconds$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (next_wave$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFinishWave.nextWave cannot be set twice.');
					}
					++next_wave$count;
					this.nextWave = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (next_wave_seconds$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFinishWave.nextWaveSeconds cannot be set twice.');
					}
					++next_wave_seconds$count;
					this.nextWaveSeconds = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
