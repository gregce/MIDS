class CreditCard:
    def __init__(self, customer, bank, acnt, limit):
        
        self.customer = customer
        self.bank = bank
        self.account = acnt
        self.limit = limit
        self.balance = 0
        
    def getcustomer(self):
        
        return self.customer
        
    def getbank(self):
        
        return self.bank
        
    def getaccount(self):
        
        return self.getaccount
        
    def getlimit(self):
        
        return self.limit
        
    def getbalance(self):
        
        return self.balance
        
    
    def charge(self, price):
        
        if price + self.balance > self.limit:
            return False
        else:
            self.balance += price
            return True
            
    def makepayment(self, amount):
        self.balance -= amount
    
        
    
        
    