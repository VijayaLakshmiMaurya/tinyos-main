
interface DIPDecision {
  command uint8_t getCommRate();
  command void resetCommRate();
  command error_t send();
}
