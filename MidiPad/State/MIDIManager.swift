import Foundation
import Combine
import CoreMIDI

public class MIDIManager: ObservableObject {
    @Published public private(set) var destinations: [MIDIDestination] = []
    @Published public var selectedDestination: MIDIEndpointRef = 0

    private(set) var client = MIDIClientRef()
    private(set) var outputPort = MIDIPortRef()

    public struct MIDIDestination: Identifiable, Equatable {
        public let id: MIDIEndpointRef
        public let name: String

        public static func == (lhs: MIDIDestination, rhs: MIDIDestination) -> Bool {
            return lhs.id == rhs.id && lhs.name == rhs.name
        }
    }

    public init() {}

    public func setupIfNeeded() {
        guard client == 0 else {
            refreshDestinations()
            return
        }

        MIDIClientCreateWithBlock("MIDIManager Client" as CFString, &client) { [weak self] notification in
            switch notification.pointee.messageID {
            case .msgObjectAdded:
                print("MIDI Object Added")
            case .msgObjectRemoved:
                print("MIDI Object Removed")
            case .msgSetupChanged:
                print("MIDI Setup Changed")
            default:
                break
            }
            DispatchQueue.main.async {
                self?.refreshDestinations()
            }
        }

        MIDIOutputPortCreate(client, "MIDIManager Output Port" as CFString, &outputPort)

        refreshDestinations()
    }

    public func refreshDestinations() {
        var newDestinations: [MIDIDestination] = []

        let count = MIDIGetNumberOfDestinations()
        for i in 0..<count {
            let endpoint = MIDIGetDestination(i)
            if endpoint != 0 {
                let endpointName = name(for: endpoint)
                let dest = MIDIDestination(id: endpoint, name: endpointName)
                newDestinations.append(dest)
            }
        }

        if selectedDestination == 0 || !newDestinations.contains(where: { $0.id == selectedDestination }) {
            selectedDestination = newDestinations.first?.id ?? 0
        }

        destinations = newDestinations
    }

    private func name(for endpoint: MIDIObjectRef) -> String {
        var param: Unmanaged<CFString>?
        let result = MIDIObjectGetStringProperty(endpoint, kMIDIPropertyName, &param)
        if result == noErr, let cfName = param?.takeRetainedValue() {
            return cfName as String
        }
        return "Unknown"
    }

    public func sendCC(controller: UInt8, value: UInt8, channel: UInt8) {
        guard outputPort != 0, selectedDestination != 0 else { return }

        var packet = MIDIPacket()
        packet.timeStamp = 0
        packet.length = 3
        packet.data.0 = 0xB0 | (channel & 0x0F)
        packet.data.1 = controller
        packet.data.2 = value

        var packetList = MIDIPacketList(numPackets: 1, packet: packet)

        MIDISend(outputPort, selectedDestination, &packetList)
    }
}
